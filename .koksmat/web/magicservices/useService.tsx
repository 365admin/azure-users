"use client";
import { useEffect, useState } from "react";

import { run } from "./run";
import { getTransactionId } from "@/app/users/server";

export function useService<T>(
  subject: string,
  ...args: string[]
): {
  result: T | undefined;
  error: string;
  isLoading: boolean;
  transactionId: string;
} {
  const [result, setresult] = useState<T | undefined>();
  const [isLoading, setisLoading] = useState(false);
  const [error, seterror] = useState("");
  const [transactionId, settransactionid] = useState("");
  useEffect(() => {
    const load = async () => {
      settransactionid(await getTransactionId());
    };
    load();
  }, []);

  useEffect(() => {
    const load = async () => {
      if (!transactionId) return;
      setisLoading(true);
      const r = await run<T>(subject, args, "", 20, transactionId);
      setisLoading(false);
      if (r.hasError) {
        seterror(r.errorMessage ?? "Unknown error");
      } else {
        setresult(r.data);
      }
    };
    load();
  }, [subject, args, transactionId]);

  return {
    result,
    error,
    isLoading,
    transactionId,
  };
}
