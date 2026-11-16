"use client";
import { useEffect, useState } from "react";
import { DEFAULT_FACTORY_GENERATION, readFactoryGeneration } from "../lib/model3Factory";

export function useFactoryGeneration() {
  const [generation, setGeneration] = useState(DEFAULT_FACTORY_GENERATION);
  useEffect(() => {
    const read = () => setGeneration(readFactoryGeneration(new URLSearchParams(window.location.search).get("factoryGeneration")));
    read();
    window.addEventListener("popstate", read);
    return () => window.removeEventListener("popstate", read);
  }, []);
  return [generation, setGeneration] as const;
}
