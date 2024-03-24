"use server";
import { run } from "@/magicservices/run";
import { randomBytes } from "crypto";

export async function createRooms(transactionId: string) {
  console.log("createRooms");

  return run(
    "meeting-infrastructure.create",
    [],
    transactionId,
    600,
    transactionId
  );
}
export async function updateRooms(transactionId: string) {
  console.log("updateRooms");
  return run(
    "meeting-infrastructure.update",
    [],
    transactionId,
    600,
    transactionId
  );
}
export async function deleteRooms(transactionId: string) {
  console.log("deleteRooms");
  return run(
    "meeting-infrastructure.delete",
    [],
    transactionId,
    600,
    transactionId
  );
}

export async function getTransactionId() {
  return randomBytes(16).toString("hex");
}
