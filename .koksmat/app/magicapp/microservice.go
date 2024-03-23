package magicapp

import (
	"context"
	"encoding/json"
	"log"
	"os"
	"path"
	"time"

	nats "github.com/nats-io/nats.go"
	"github.com/nats-io/nats.go/micro"
	"github.com/spf13/viper"

	"github.com/365admin/azure-users/cmds"
	"github.com/365admin/azure-users/utils"
)

type ServiceRequest struct {
	Args    []string `json:"args"`
	Body    string   `json:"body"`
	Channel string   `json:"channel"`
	Timeout int      `json:"timeout"`
}

func UpdateUsers(req micro.Request) {
	var payload ServiceRequest
	_ = json.Unmarshal([]byte(req.Data()), &payload)
	log.Println("Page Info", payload)
	_, err := cmds.MagicPepplPost(context.Background(), payload.Args)

	if err != nil {
		log.Println(err)
		req.Respond([]byte(err.Error()))
		return
	}
	log.Println("done")
	resultingFile := path.Join(utils.WorkDir("sharepoint-governance"), "pageinfo.response.json")
	data, err := os.ReadFile(resultingFile)
	if err != nil {
		return
	}

	req.Respond(data)

}

func StartMicroService() {
	// Parent context cancels connecting/reconnecting altogether.
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	var err error
	var nc *nats.Conn
	opts := []nats.Option{

		nats.ReconnectWait(2 * time.Second),
		nats.ReconnectHandler(func(c *nats.Conn) {
			log.Println("Reconnected to", c.ConnectedUrl())
		}),
		nats.DisconnectHandler(func(c *nats.Conn) {
			log.Println("Disconnected from NATS")
		}),
		nats.ClosedHandler(func(c *nats.Conn) {
			log.Println("NATS connection is closed.")
		}),
	}

	go func() {
		natsServer := viper.GetString("NATS")
		if natsServer == "" {
			natsServer = "nats://127.0.0.1:4222"
		}
		log.Println("Connecting to", natsServer)
		nc, err = nats.Connect(natsServer, opts...)
	}()
	retryCount := 0
WaitForEstablishedConnection:
	for {
		if err != nil {
			log.Fatal(err)
		}
		ctx, cancel := context.WithCancel(context.Background())
		defer cancel()
		// Wait for context to be canceled either by timeout
		// or because of establishing a connection...
		select {
		case <-ctx.Done():
			break WaitForEstablishedConnection
		default:
		}

		if nc == nil || !nc.IsConnected() {
			if retryCount != 0 {
				log.Println("Connection not ready")
			}
			retryCount++
			time.Sleep(200 * time.Millisecond)
			continue
		}
		break WaitForEstablishedConnection
	}
	if ctx.Err() != nil {
		log.Fatal(ctx.Err())
	}
	log.Println("Connected")
	srv, err := micro.AddService(nc, micro.Config{
		Name: "azure-users",

		Version:     "0.0.1",
		Description: "Azure Users Service",
	})
	root := srv.AddGroup("azure-users")
	pages := root.AddGroup("users")
	pages.AddEndpoint("update", micro.HandlerFunc(UpdateUsers))
	for {
		if nc.IsClosed() {
			break
		}

		time.Sleep(1 * time.Second)
	}

	// Disconnect and flush pending messages
	if err := nc.Drain(); err != nil {
		log.Println(err)
	}
	log.Println("Disconnected")

}
