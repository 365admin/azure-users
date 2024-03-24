"use client";
import { Button } from "@/components/ui/button";
import Logo from "@/koksmat/components/logo";
import { useContext, useEffect, useState } from "react";
import { synsUsers, getTransactionId, runTasks } from "./server";
import ShowNatsLog from "./components/nats";
import { set } from "date-fns";
import { Result } from "@/koksmat/httphelper";
import { MagicboxContext } from "@/koksmat/magicbox-context";
import { useService } from "@/magicservices/useService";

export const dynamic = "force-dynamic";

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
const SERVICENAME = "azure-users";

export default function CavaHome() {
  const [running, setrunning] = useState(false);
  const [result, setresult] = useState("");
  const [error, seterror] = useState("");
  const [logEntries, setlogEntries] = useState<string[]>([]);
  const [transactionId, settransactionid] = useState("");

  const magicbox = useContext(MagicboxContext);
  const health = useService<string>(SERVICENAME + ".health.status");
  const { user } = magicbox;

  const run = async (method: (id: string) => Promise<Result<any>>) => {
    setrunning(true);
    setresult("");
    seterror("");

    const result = await method(transactionId);

    setresult(result.data || "");
    seterror(result.errorMessage || "");
    setrunning(false);
  };

  useEffect(() => {
    if (!health) return;
    if (health.isLoading) return;
    if (health.error) {
      seterror(
        health.error === "503"
          ? "Service '" + SERVICENAME + "' is not available"
          : health.error
      );
    }
  }, [health]);

  const doRunTasks = async () => run(runTasks);
  const doSyncUsers = async () => run(synsUsers);

  useEffect(() => {
    const load = async () => {
      if (!user?.email) return;
      const transactionId = await getTransactionId();
      settransactionid(user.email + "." + transactionId);
    };

    load();
  }, [user]);
  if (!user?.email)
    return (
      <div>
        <Button
          onClick={async () => {
            const signedIn = await magicbox.signIn(["User.Read"], "");
          }}
        >
          Sign In
        </Button>
      </div>
    );
  return (
    <div>
      <div className="space-y-3 p-4">
        {user?.name && <div>Logged in as {user.name}</div>}
        {error && <div className="text-red-500">Error: {error}</div>}
        {health && !health.error && (
          <div>
            <div>
              <Button disabled={running} onClick={() => doSyncUsers()}>
                Update List
              </Button>
            </div>
            <div>
              <Button disabled={running} onClick={() => doRunTasks()}>
                Execute Tasks
              </Button>
            </div>
          </div>
        )}
        <ShowNatsLog subject={transactionId} />
        {/* <div>
       <Button disabled={running} onClick={()=>run()}>Change Email</Button>
       </div>
       <div>
       <Button disabled={running} onClick={()=>run()}>Run all</Button>
       </div>        */}
      </div>

      {running && <div>Running... </div>}
      {result && <div>Result: {result}</div>}

      {transactionId && false && (
        <div>
          Copy this command to your terminal
          <div className="mt-4">
            <textarea
              value={"nats publish log." + transactionId + " test"}
              className="w-[100%] font-mono text-sm"
            ></textarea>
          </div>
          {/* <ShowNatsLog  subject={"log."+transactionId} /> */}
        </div>
      )}
    </div>
  );
}
