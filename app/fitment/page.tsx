export default function Fitment() {
  return (
    <main className="min-h-screen bg-black text-white p-6">
      <h1 className="text-2xl font-bold mb-6">Aggressive Daily Setup</h1>

      <div className="bg-gray-900 p-6 rounded-xl space-y-4">
        <div>
          <h2 className="text-lg font-semibold">Front</h2>
          <p>20x9 +25</p>
          <p>245/35R20</p>
        </div>

        <div>
          <h2 className="text-lg font-semibold">Rear</h2>
          <p>20x10.5 +38</p>
          <p>285/30R20</p>
        </div>

        <div className="pt-4 border-t border-gray-700">
          <h3 className="font-semibold mb-2">Fitment Metrics</h3>
          <p>+22mm poke</p>
          <p>-6mm inner clearance</p>
          <p>+0.8% diameter</p>
        </div>

        <div className="pt-4 border-t border-gray-700">
          <h3 className="font-semibold">Verdict</h3>
          <p className="text-gray-400">
            Strong aggressive stance with manageable clearance. Ideal for coilovers or mild drop.
          </p>
        </div>
      </div>
    </main>
  );
}
