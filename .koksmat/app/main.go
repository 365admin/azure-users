package main

import (
	"runtime/debug"
	"strings"

	"github.com/365admin/azure-users/magicapp"
)

func main() {
	info, _ := debug.ReadBuildInfo()

	// split info.Main.Path by / and get the last element
	s1 := strings.Split(info.Main.Path, "/")
	name := s1[len(s1)-1]
	description := `---
title: azure-users
description: Describe the main purpose of this kitchen
---

# azure-users
`
	magicapp.Setup(".env")
	magicapp.RegisterServeCmd("azure-users", description, "0.0.1", 8080)
	magicapp.RegisterCmds()
	magicapp.RegisterServiceCmd()
	magicapp.Execute(name, "azure-users", "")
}
