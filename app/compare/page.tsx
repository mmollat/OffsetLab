export default function Compare() {
  return (
    <main className="min-h-screen bg-black text-white p-6">
      <h1 className="text-2xl font-bold mb-6">Compare Setup</h1>

      <div className="bg-gray-900 p-6 rounded-xl space-y-4">
        <p>OEM: 20x9 +34</p>
        <p>New: 20x9 +25</p>

        <div className="pt-4 border-t border-gray-700">
          <p>+12mm poke</p>
          <p>-5mm inner clearance</p>
          <p>+0.5% diameter</p>
        </div>

        <div className="pt-4 border-t border-gray-700">
          <p className="text-gray-400">
            More aggressive stance with minimal clearance impact.
          </p>
        </div>
      </div>
    </main>
  );
}
