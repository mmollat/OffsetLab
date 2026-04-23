'use client';

import { useMemo, useState } from 'react';
import { Card } from '@/app/components/Card';
import { SiteHeader } from '@/app/components/SiteHeader';
import { MetricRow } from '@/app/components/MetricRow';
import { calculateCustomFitment, getVehicleOptions } from '@/app/lib';

export default function ComparePage() {
  const vehicles = getVehicleOptions();
  const [vehicleId, setVehicleId] = useState('model3-perf-2021-2023');
  const [frontWidth, setFrontWidth] = useState('9');
  const [frontDiameter, setFrontDiameter] = useState('20');
  const [frontOffset, setFrontOffset] = useState('25');
  const [rearWidth, setRearWidth] = useState('10.5');
  const [rearDiameter, setRearDiameter] = useState('20');
  const [rearOffset, setRearOffset] = useState('38');
  const [frontTire, setFrontTire] = useState('245/35R20');
  const [rearTire, setRearTire] = useState('285/30R20');

  const result = useMemo(() => {
    try {
      return calculateCustomFitment({
        vehicleId,
        frontWidthIn: Number(frontWidth),
        frontDiameterIn: Number(frontDiameter),
        frontOffset: Number(frontOffset),
        rearWidthIn: Number(rearWidth),
        rearDiameterIn: Number(rearDiameter),
        rearOffset: Number(rearOffset),
        frontTire,
        rearTire,
      });
    } catch {
      return null;
    }
  }, [vehicleId, frontWidth, frontDiameter, frontOffset, rearWidth, rearDiameter, rearOffset, frontTire, rearTire]);

  const numberFieldClass = 'w-full rounded-2xl border border-border bg-surface2 px-4 py-3 text-sm text-white';

  return (
    <main className="min-h-screen bg-background text-white">
      <SiteHeader />
      <div className="mx-auto px-6 py-8 grid max-w-7xl gap-6 lg:grid-cols-[380px_1fr]">
        <Card className="h-fit p-6">
          <p className="text-sm uppercase tracking-[0.25em] text-muted">Precision fitment. No guesswork.</p>
          <h1 className="mt-2 text-2xl font-semibold">Compare setup</h1>
          <p className="mt-3 text-sm text-muted">Enter a custom setup and compare it against the OEM baseline.</p>

          <div className="mt-6 space-y-4">
            <div>
              <label className="mb-2 block text-sm text-muted">Vehicle</label>
              <select value={vehicleId} onChange={(e) => setVehicleId(e.target.value)} className={numberFieldClass}>
                {vehicles.map((vehicle) => (
                  <option key={vehicle.id} value={vehicle.id}>{vehicle.yearRange} Tesla Model 3 {vehicle.trim}</option>
                ))}
              </select>
            </div>

            <div className="grid grid-cols-2 gap-3">
              <div>
                <label className="mb-2 block text-sm text-muted">Front width</label>
                <input value={frontWidth} onChange={(e) => setFrontWidth(e.target.value)} className={numberFieldClass} />
              </div>
              <div>
                <label className="mb-2 block text-sm text-muted">Front diameter</label>
                <input value={frontDiameter} onChange={(e) => setFrontDiameter(e.target.value)} className={numberFieldClass} />
              </div>
              <div>
                <label className="mb-2 block text-sm text-muted">Front offset</label>
                <input value={frontOffset} onChange={(e) => setFrontOffset(e.target.value)} className={numberFieldClass} />
              </div>
              <div>
                <label className="mb-2 block text-sm text-muted">Rear width</label>
                <input value={rearWidth} onChange={(e) => setRearWidth(e.target.value)} className={numberFieldClass} />
              </div>
              <div>
                <label className="mb-2 block text-sm text-muted">Rear diameter</label>
                <input value={rearDiameter} onChange={(e) => setRearDiameter(e.target.value)} className={numberFieldClass} />
              </div>
              <div>
                <label className="mb-2 block text-sm text-muted">Rear offset</label>
                <input value={rearOffset} onChange={(e) => setRearOffset(e.target.value)} className={numberFieldClass} />
              </div>
            </div>

            <div>
              <label className="mb-2 block text-sm text-muted">Front tire</label>
              <input value={frontTire} onChange={(e) => setFrontTire(e.target.value)} className={numberFieldClass} />
            </div>
            <div>
              <label className="mb-2 block text-sm text-muted">Rear tire</label>
              <input value={rearTire} onChange={(e) => setRearTire(e.target.value)} className={numberFieldClass} />
            </div>
          </div>
        </Card>

        {result ? (
          <div className="space-y-6">
            <Card className="p-6">
              <p className="text-sm uppercase tracking-[0.25em] text-muted">Comparison</p>
              <h2 className="mt-2 text-3xl font-semibold">{result.baseline.yearRange} Tesla Model 3 {result.baseline.trim}</h2>
              <div className="mt-8 grid gap-4 md:grid-cols-2">
                <Card className="p-5">
                  <p className="text-sm uppercase tracking-[0.25em] text-muted">OEM baseline</p>
                  <p className="mt-3 text-lg text-white">Front: {result.baseline.stockFrontDiameterIn}x{result.baseline.stockFrontWidthIn} +{result.baseline.stockFrontOffset} / {result.baseline.stockFrontTire}</p>
                  <p className="mt-2 text-lg text-white">Rear: {result.baseline.stockRearDiameterIn}x{result.baseline.stockRearWidthIn} +{result.baseline.stockRearOffset} / {result.baseline.stockRearTire}</p>
                </Card>
                <Card className="p-5">
                  <p className="text-sm uppercase tracking-[0.25em] text-muted">Custom setup</p>
                  <p className="mt-3 text-lg text-white">Front: {result.front.wheel} / {result.front.tire}</p>
                  <p className="mt-2 text-lg text-white">Rear: {result.rear.wheel} / {result.rear.tire}</p>
                </Card>
              </div>
            </Card>

            <div className="grid gap-6 lg:grid-cols-2">
              <Card className="p-6">
                <p className="text-sm uppercase tracking-[0.25em] text-muted">Front metrics</p>
                <div className="mt-4">
                  <MetricRow label="Poke change" value={`${result.front.pokeMm > 0 ? '+' : ''}${result.front.pokeMm} mm`} />
                  <MetricRow label="Inner clearance change" value={`${result.front.innerClearanceMm > 0 ? '-' : '+'}${Math.abs(result.front.innerClearanceMm)} mm`} />
                  <MetricRow label="Tire diameter change" value={`${result.front.diameterChangePct > 0 ? '+' : ''}${result.front.diameterChangePct}%`} />
                </div>
              </Card>
              <Card className="p-6">
                <p className="text-sm uppercase tracking-[0.25em] text-muted">Rear metrics</p>
                <div className="mt-4">
                  <MetricRow label="Poke change" value={`${result.rear.pokeMm > 0 ? '+' : ''}${result.rear.pokeMm} mm`} />
                  <MetricRow label="Inner clearance change" value={`${result.rear.innerClearanceMm > 0 ? '-' : '+'}${Math.abs(result.rear.innerClearanceMm)} mm`} />
                  <MetricRow label="Tire diameter change" value={`${result.rear.diameterChangePct > 0 ? '+' : ''}${result.rear.diameterChangePct}%`} />
                </div>
              </Card>
            </div>

            <Card className="p-6">
              <p className="text-sm uppercase tracking-[0.25em] text-muted">Risk summary</p>
              <p className="mt-3 text-4xl font-semibold">{result.riskLevel}</p>
            </Card>
          </div>
        ) : (
          <Card className="p-6"><p className="text-white">Enter valid tire sizes like 245/35R20.</p></Card>
        )}
      </div>
    </main>
  );
}
