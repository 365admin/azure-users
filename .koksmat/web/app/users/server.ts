"use server";
import { run } from "@/magicservices/run";
import { randomBytes } from "crypto";

export async function synsUsers(transactionId: string) {
  console.log("azure-users.users.update");
  return run("azure-users.users.update", [], transactionId, 600, transactionId);
}
export async function runTasks(transactionId: string) {
  console.log("azure-users.users.runtasks");
  return run(
    "azure-users.users.runtasks",
    [],
    transactionId,
    600,
    transactionId
  );
}

export async function getTransactionId() {
  return randomBytes(16).toString("hex");
}
