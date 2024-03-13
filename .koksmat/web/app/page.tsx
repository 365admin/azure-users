"use client"

import { redirect } from "next/navigation";
import { useEffect } from "react";
import { APPNAME } from "./global";

export default function Home(){
    useEffect(() => {
   redirect("/"+APPNAME)
    }, [])
    
    return <div>
       
    </div>
}