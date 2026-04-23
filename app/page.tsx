import Image from "next/image";
import Link from "next/link";

export default function Home() {
  return (
    <main className="min-h-screen bg-black text-white flex flex-col items-center justify-center text-center px-6">
      <Image
        src="/logos/offset-lab-primary-logo.png"
        alt="Offset Lab"
        width={500}
        height={200}
        className="mb-6"
      />

      <p className="text-lg text-gray-400 mb-6">
        Precision fitment. No guesswork.
      </p>

      <div className="flex gap-4">
        <Link href="/fitment" className="bg-white text-black px-6 py-3 rounded-xl">
          Start Fitment
        </Link>
        <Link href="/compare" className="border border-gray-500 px-6 py-3 rounded-xl">
          Compare Setup
        </Link>
      </div>
    </main>
  );
}
