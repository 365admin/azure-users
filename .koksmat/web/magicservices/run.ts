"use server";
import { Result } from "@/koksmat/httphelper";
import { NatsConnection, connect, StringCodec } from "nats";

export interface MagicRequest {
  args: any[];
  body: string;
  channel: string;
  timeout: number;
}

export async function run<T>(
  subject: string,
  args: string[],
  body: string,
  timeout: number,
  channel: string
): Promise<Result<T>> {
  const req: MagicRequest = {
    args,
    body,
    channel,
    timeout,
  };

  let errorMessage = "";
  let hasError = false;
  let nc: NatsConnection | null = null;
  let data: T | undefined = undefined;
  try {
    nc = await connect({
      servers: [process.env.NATS ?? "nats://127.0.0.1:4222"],
    });

    const payload = JSON.stringify(req);
    const sc = StringCodec();
    const encodedPayload = sc.encode(payload);
    const response = await nc
      .request(subject, encodedPayload, { timeout: timeout * 1000 })
      .catch((error) => {
        hasError = true;
        errorMessage = (error as any).message;
      });
    if (response) {
      data = JSON.parse(sc.decode(response.data));
    }
  } catch (error) {
    hasError = true;
    errorMessage = (error as any).message;
  } finally {
    if (nc) {
      nc.close();
    }
  }

  const result: Result<T> = {
    hasError,
    errorMessage,
    data,
  };

  return result;
}
