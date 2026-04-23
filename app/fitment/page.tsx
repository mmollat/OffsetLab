'use client';

import { useMemo, useState } from 'react';
import { Badge } from '@/app/components/Badge';
import { Card } from '@/app/components/Card';
import { SiteHeader } from '@/app/components/SiteHeader';
import { MetricRow } from '@/app/components/MetricRow';
import { calculateRecommendation, getMatchingRecommendations, getVehicleOptions } from '@/app/lib';
import type { StyleKey, SuspensionKey } from '@/app/data/model3';

export default function FitmentPage() {
  const vehicles = getVehicleOptions();
  const [vehicleId, setVehicleId] = useState('model3-perf-2021-2023');
  const [style, setStyle] = useState<StyleKey>('Aggressive');
  const [suspension, setSuspension] = useState<SuspensionKey>('Coilovers');

  const recommendation = useMemo(() => calculateRecommendation(vehicleId, style, suspension), [vehicleId, style, suspension]);
  const alternates = useMemo(() => getMatchingRecommendations(vehicleId, style, suspension).filter((item) => item.alternate), [vehicleId, style, suspension]);

  return (
    <main className="min-h-screen bg-background text-white">
      <SiteHeader />
      <div className="mx-auto px-6 py-8 grid max-w-7xl gap-6 lg:grid-cols-[380px_1fr]">
        <Card className="h-fit p-6">
          <p className="text-sm uppercase tracking-[0.25em] text-muted">Precision fitment. No guesswork.</p>
          <h1 className="mt-2 text-2xl font-semibold">Fitment search</h1>
          <p className="mt-3 text-sm text-muted">Choose your trim, fitment target, and suspension type.</p>

          <div className="mt-6 space-y-5">
            <div>
              <label className="mb-2 block text-sm text-muted">Vehicle</label>
              <select value={vehicleId} onChange={(e) => setVehicleId(e.target.value)} className="w-full rounded-2xl border border-border bg-surface2 px-4 py-3 text-sm text-white">
                {vehicles.map((vehicle) => (
                  <option key={vehicle.id} value={vehicle.id}>
                    {vehicle.yearRange} Tesla Model 3 {vehicle.trim}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="mb-2 block text-sm text-muted">Style</label>
              <div className="grid grid-cols-3 gap-2">
                {(['OEM+', 'Flush', 'Aggressive'] as StyleKey[]).map((item) => (
                  <button
                    key={item}
                    onClick={() => setStyle(item)}
                    className={`rounded-2xl border px-3 py-3 text-sm font-medium ${style === item ? 'border-white bg-white text-black' : 'border-border bg-surface2 text-white'}`}
                  >
                    {item}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <label className="mb-2 block text-sm text-muted">Suspension</label>
              <div className="grid grid-cols-1 gap-2">
                {(['Stock', 'Lowering Springs', 'Coilovers'] as SuspensionKey[]).map((item) => (
                  <button
                    key={item}
                    onClick={() => setSuspension(item)}
                    className={`rounded-2xl border px-4 py-3 text-left text-sm font-medium ${suspension === item ? 'border-white bg-white text-black' : 'border-border bg-surface2 text-white'}`}
                  >
                    {item}
                  </button>
                ))}
              </div>
            </div>
          </div>
        </Card>

        <div className="space-y-6">
          {recommendation ? (
            <>
              <Card className="p-6">
                <div className="flex flex-wrap items-start justify-between gap-4">
                  <div>
                    <p className="text-sm uppercase tracking-[0.25em] text-muted">Recommended setup</p>
                    <h2 className="mt-2 text-3xl font-semibold">{recommendation.baseline.yearRange} Tesla Model 3 {recommendation.baseline.trim}</h2>
                    <p className="mt-2 text-lg text-white">{recommendation.setupName}</p>
                  </div>
                  <div className="flex flex-wrap gap-2">
                    <Badge>{recommendation.riskLevel} risk</Badge>
                    <Badge>{recommendation.confidence} confidence</Badge>
                    <Badge>{recommendation.bestFor}</Badge>
                  </div>
                </div>

                <div className="mt-8 grid gap-4 md:grid-cols-2">
                  <Card className="p-5">
                    <p className="text-sm uppercase tracking-[0.25em] text-muted">Front</p>
                    <p className="mt-3 text-3xl font-semibold">{recommendation.front.wheel}</p>
                    <p className="mt-2 text-lg text-white">{recommendation.front.tire}</p>
                  </Card>
                  <Card className="p-5">
                    <p className="text-sm uppercase tracking-[0.25em] text-muted">Rear</p>
                    <p className="mt-3 text-3xl font-semibold">{recommendation.rear.wheel}</p>
                    <p className="mt-2 text-lg text-white">{recommendation.rear.tire}</p>
                  </Card>
                </div>

                <div className="mt-8 grid gap-4 lg:grid-cols-[1.2fr_0.8fr]">
                  <Card className="p-5">
                    <p className="text-sm uppercase tracking-[0.25em] text-muted">Fitment metrics</p>
                    <div className="mt-4">
                      <MetricRow label="Front poke change" value={`${recommendation.front.pokeMm > 0 ? '+' : ''}${recommendation.front.pokeMm} mm`} />
                      <MetricRow label="Rear poke change" value={`${recommendation.rear.pokeMm > 0 ? '+' : ''}${recommendation.rear.pokeMm} mm`} />
                      <MetricRow label="Front inner clearance change" value={`${recommendation.front.innerClearanceMm > 0 ? '-' : '+'}${Math.abs(recommendation.front.innerClearanceMm)} mm`} sub="Positive loss means tighter clearance than stock." />
                      <MetricRow label="Rear inner clearance change" value={`${recommendation.rear.innerClearanceMm > 0 ? '-' : '+'}${Math.abs(recommendation.rear.innerClearanceMm)} mm`} sub="Positive loss means tighter clearance than stock." />
                      <MetricRow label="Front tire diameter change" value={`${recommendation.front.diameterChangePct > 0 ? '+' : ''}${recommendation.front.diameterChangePct}%`} />
                      <MetricRow label="Rear tire diameter change" value={`${recommendation.rear.diameterChangePct > 0 ? '+' : ''}${recommendation.rear.diameterChangePct}%`} />
                    </div>
                  </Card>

                  <Card className="p-5">
                    <p className="text-sm uppercase tracking-[0.25em] text-muted">Scores</p>
                    <div className="mt-4 space-y-4">
                      <div>
                        <p className="text-sm text-muted">Visual aggression</p>
                        <p className="mt-1 text-3xl font-semibold">{recommendation.visualAggression}/10</p>
                      </div>
                      <div>
                        <p className="text-sm text-muted">Daily drivability</p>
                        <p className="mt-1 text-3xl font-semibold">{recommendation.drivability}/10</p>
                      </div>
                      <div>
                        <p className="text-sm text-muted">Verdict</p>
                        <p className="mt-2 text-sm leading-6 text-white">{recommendation.verdict}</p>
                        <p className="mt-2 text-sm leading-6 text-muted">{recommendation.note}</p>
                      </div>
                    </div>
                  </Card>
                </div>
              </Card>

              <div className="grid gap-6 lg:grid-cols-[1fr_1fr]">
                <Card className="p-6">
                  <p className="text-sm uppercase tracking-[0.25em] text-muted">Hardware reference</p>
                  <div className="mt-4">
                    <MetricRow label="Bolt pattern" value={recommendation.baseline.boltPattern} />
                    <MetricRow label="Center bore" value={`${recommendation.baseline.centerBoreMm} mm`} />
                    <MetricRow label="Thread spec" value={recommendation.baseline.threadSpec} />
                    <MetricRow label="Torque" value={`${recommendation.baseline.torqueLbFt} lb-ft`} />
                  </div>
                </Card>

                <Card className="p-6">
                  <p className="text-sm uppercase tracking-[0.25em] text-muted">Warnings</p>
                  <div className="mt-4 space-y-3">
                    {recommendation.warnings.length ? recommendation.warnings.map((warning) => (
                      <div key={warning} className="rounded-2xl border border-border bg-surface2 px-4 py-3 text-sm text-white">
                        {warning}
                      </div>
                    )) : <div className="rounded-2xl border border-border bg-surface2 px-4 py-3 text-sm text-white">No major warning flags.</div>}
                  </div>
                </Card>
              </div>

              {alternates.length ? (
                <Card className="p-6">
                  <p className="text-sm uppercase tracking-[0.25em] text-muted">Alternate setup</p>
                  <div className="mt-4 grid gap-4 md:grid-cols-2">
                    {alternates.map((item) => (
                      <div key={item.setupType} className="rounded-2xl border border-border bg-surface2 p-5">
                        <p className="text-lg font-semibold text-white">{item.setupType}</p>
                        <p className="mt-3 text-sm text-muted">Front</p>
                        <p className="mt-1 text-base text-white">{item.frontDiameterIn}x{item.frontWidthIn} +{item.frontOffset} / {item.frontTire}</p>
                        <p className="mt-3 text-sm text-muted">Rear</p>
                        <p className="mt-1 text-base text-white">{item.rearDiameterIn}x{item.rearWidthIn} +{item.rearOffset} / {item.rearTire}</p>
                      </div>
                    ))}
                  </div>
                </Card>
              ) : null}
            </>
          ) : (
            <Card className="p-6">
              <p className="text-white">No recommendation found for that combo yet.</p>
            </Card>
          )}
        </div>
      </div>
    </main>
  );
}
