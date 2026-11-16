"use client";
import type { FactoryGeneration } from "../lib/model3Factory";

export default function FactoryGenerationSelect({value, onChange}: {value: FactoryGeneration; onChange: (value: FactoryGeneration) => void}) {
  return (
    <label className="block text-sm text-white/80">
      Stock baseline · Model 3 Performance (US)
      <select className="ml-3 rounded-lg border border-white/20 bg-zinc-900 p-3 text-white" value={value}
        onChange={(event) => onChange(event.target.value as FactoryGeneration)}>
        <option value="2017-2023">2017–2023 manual · 20-inch square</option>
        <option value="2024-plus">2024+ · 20-inch staggered</option>
      </select>
      <span className="mt-2 block text-xs text-white/50">Changes only the stock comparison reference. Your selected aftermarket setup stays the same. Check your vehicle&apos;s fitted factory package.</span>
    </label>
  );
}
