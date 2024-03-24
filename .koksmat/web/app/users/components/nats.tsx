"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { connect, NatsConnection, StringCodec } from "nats.ws";



export default function ShowNatsLog(props: { subject: string }) {
  const logEntries2 = useRef<string[]>([])


  return (
    <div className="border">

      {logEntries2.current.map((entry, i) => (
      <div key={i}>
        {entry}</div>
    
      ))}
    </div>
  );
}
