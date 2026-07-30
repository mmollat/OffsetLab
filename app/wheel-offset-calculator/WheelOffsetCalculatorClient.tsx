"use client";

import { useMemo, useState } from "react";
import { compareWheelFitment } from "../lib/compareMath";

const examples = [
  {
    label: "OEM+ street",
    stockWidth: "8.5",
    stockOffset: "35",
    newWidth: "9.5",
    newOffset: "25",
  },
  {
    label: "Track square",
    stockWidth: "9",
    stockOffset: "30",
    newWidth: "10.5",
    newOffset: "22",
  },
  {
    label: "Conservative daily",
    stockWidth: "8",
    stockOffset: "45",
    newWidth: "8.5",
    newOffset: "38",
  },
] as const;

function parseNumber(value: string) {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : null;
}

function formatSigned(value: number) {
  return value > 0 ? `+${value}` : `${value}`;
}

export default function WheelOffsetCalculatorClient() {
  const [stockWidth, setStockWidth] = useState("8.5");
  const [stockOffset, setStockOffset] = useState("35");
  const [newWidth, setNewWidth] = useState("9.5");
  const [newOffset, setNewOffset] = useState("25");

  const result = useMemo(() => {
    const oemWidth = parseNumber(stockWidth);
    const oemOffset = parseNumber(stockOffset);
    const selectedWidth = parseNumber(newWidth);
    const selectedOffset = parseNumber(newOffset);

    if (
      oemWidth === null ||
      oemOffset === null ||
      selectedWidth === null ||
      selectedOffset === null
    ) {
      return null;
    }

    return compareWheelFitment(
      { width: oemWidth, offset: oemOffset },
      { width: selectedWidth, offset: selectedOffset }
    );
  }, [newOffset, newWidth, stockOffset, stockWidth]);

  return (
    <section
      aria-labelledby="wheel-offset-tool"
      className="rounded-xl border border-white/10 bg-[#0a0a0c] p-5 shadow-2xl shadow-black/30 sm:p-7"
    >
      <div className="flex flex-col justify-between gap-4 border-b border-white/10 pb-5 md:flex-row md:items-end">
        <div>
          <p className="text-xs font-black uppercase tracking-[0.22em] text-red-500">
            Wheel Offset Calculator
          </p>
          <h2 id="wheel-offset-tool" className="mt-3 text-2xl font-black tracking-[-0.03em]">
            Compare stock vs new wheel fitment
          </h2>
        </div>
        <div className="flex flex-wrap gap-2">
          {examples.map((example) => (
            <button
              key={example.label}
              type="button"
              onClick={() => {
                setStockWidth(example.stockWidth);
                setStockOffset(example.stockOffset);
                setNewWidth(example.newWidth);
                setNewOffset(example.newOffset);
              }}
              className="rounded-md border border-white/10 bg-white/[0.04] px-3 py-2 text-xs font-bold text-white/70 transition hover:border-red-400/50 hover:text-white"
            >
              {example.label}
            </button>
          ))}
        </div>
      </div>

      <div className="mt-6 grid gap-4 md:grid-cols-2">
        <WheelInputs
          title="Current wheel"
          width={stockWidth}
          offset={stockOffset}
          onWidthChange={setStockWidth}
          onOffsetChange={setStockOffset}
        />
        <WheelInputs
          title="New wheel"
          width={newWidth}
          offset={newOffset}
          onWidthChange={setNewWidth}
          onOffsetChange={setNewOffset}
        />
      </div>

      <div className="mt-6 grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
        <ResultCard
          label="Outer poke"
          value={result ? `${formatSigned(result.outerChangeMm)} mm` : "Check input"}
          copy="Positive means the new wheel sits farther toward the fender."
        />
        <ResultCard
          label="Inner clearance"
          value={result ? `${formatSigned(result.innerClearanceChangeMm)} mm` : "Check input"}
          copy="Negative means the new wheel is closer to suspension."
        />
        <ResultCard
          label="Width change"
          value={result ? `${formatSigned(result.widthChangeMm)} mm` : "Check input"}
          copy="Total wheel width difference converted from inches to mm."
        />
        <ResultCard
          label="Track change"
          value={result ? `${formatSigned(result.trackChangeMm)} mm` : "Check input"}
          copy="Estimated per-axle track width change from both sides."
        />
      </div>
    </section>
  );
}

function WheelInputs({
  title,
  width,
  offset,
  onWidthChange,
  onOffsetChange,
}: {
  title: string;
  width: string;
  offset: string;
  onWidthChange: (value: string) => void;
  onOffsetChange: (value: string) => void;
}) {
  return (
    <div className="rounded-lg border border-white/10 bg-black/30 p-4">
      <h3 className="text-sm font-black uppercase tracking-[0.16em] text-white/65">{title}</h3>
      <div className="mt-4 grid gap-3 sm:grid-cols-2">
        <label className="block">
          <span className="text-xs font-bold text-white/45">Wheel width</span>
          <div className="mt-2 flex overflow-hidden rounded-md border border-white/10 bg-black">
            <input
              type="number"
              inputMode="decimal"
              step="0.5"
              value={width}
              onChange={(event) => onWidthChange(event.target.value)}
              className="min-h-12 w-full bg-transparent px-3 text-base font-bold text-white outline-none"
            />
            <span className="grid w-12 place-items-center border-l border-white/10 text-xs text-white/45">
              in
            </span>
          </div>
        </label>
        <label className="block">
          <span className="text-xs font-bold text-white/45">Offset</span>
          <div className="mt-2 flex overflow-hidden rounded-md border border-white/10 bg-black">
            <span className="grid w-12 place-items-center border-r border-white/10 text-xs text-white/45">
              ET
            </span>
            <input
              type="number"
              inputMode="numeric"
              step="1"
              value={offset}
              onChange={(event) => onOffsetChange(event.target.value)}
              className="min-h-12 w-full bg-transparent px-3 text-base font-bold text-white outline-none"
            />
          </div>
        </label>
      </div>
    </div>
  );
}

function ResultCard({ label, value, copy }: { label: string; value: string; copy: string }) {
  return (
    <div className="rounded-lg border border-white/10 bg-white/[0.035] p-4">
      <p className="text-[10px] font-black uppercase tracking-[0.2em] text-white/38">{label}</p>
      <p className="mt-3 text-3xl font-black tracking-[-0.04em] text-white">{value}</p>
      <p className="mt-3 text-xs leading-5 text-white/45">{copy}</p>
    </div>
  );
}
