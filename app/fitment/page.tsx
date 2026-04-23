"use client";

import { Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { models, trims, TeslaModelKey } from "../data/tesla";

function FitmentContent() {
  const router = useRouter();
  const params = useSearchParams();

  const model = (params.get("model") || "Model 3") as TeslaModelKey;
  const trim = params.get("trim") || "Performance";
  const style = params.get("style") || "aggressive";

  function update(key: string, value: string) {
    const newParams = new URLSearchParams(params.toString());
    newParams.set(key, value);
    router.push(("/fitment?" + newParams.toString()) as never);
  }

  return (
    <main style={{ padding: 20 }}>
      <h1>Find Your Fitment</h1>

      <div style={{ marginTop: 20 }}>
        <select value={model} onChange={(e) => update("model", e.target.value)}>
          {models.map((m) => (
            <option key={m}>{m}</option>
          ))}
        </select>

        <select value={trim} onChange={(e) => update("trim", e.target.value)}>
          {trims[model].map((t) => (
            <option key={t}>{t}</option>
          ))}
        </select>

        <select value={style} onChange={(e) => update("style", e.target.value)}>
          <option value="oemplus">OEM+</option>
          <option value="flush">Flush</option>
          <option value="aggressive">Aggressive</option>
        </select>
      </div>

      <div style={{ marginTop: 30 }}>
        <p>
          <b>
            {model} {trim}
          </b>
        </p>
        <p>{style} setup</p>
      </div>

      <button onClick={() => navigator.clipboard.writeText(window.location.href)}>
        Copy Link
      </button>
    </main>
  );
}

export default function FitmentPage() {
  return (
    <Suspense fallback={<main style={{ padding: 20 }}>Loading fitment...</main>}>
      <FitmentContent />
    </Suspense>
  );
}
