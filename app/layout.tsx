import './globals.css'
import type { Metadata } from 'next'
import Image from 'next/image'
import Link from 'next/link'
import { Analytics } from '@vercel/analytics/react'

export const metadata: Metadata = {
  title: 'Offset Lab',
  description: 'Precision fitment tool',
}

function Nav() {
  return (
    <nav className="w-full border-b border-neutral-800 bg-black px-6 py-4 flex items-center justify-between">
      <Link href="/" className="flex items-center">
        <Image
          src="/logos/offset-lab-secondary-logo.png"
          alt="Offset Lab"
          width={160}
          height={40}
          priority
        />
      </Link>

      <div className="flex gap-6 text-sm text-neutral-400">
        <Link href="/fitment" className="hover:text-white transition">
          Fitment
        </Link>
        <Link href="/compare" className="hover:text-white transition">
          Compare
        </Link>
        <Link href="/gallery" className="hover:text-white transition">
          Gallery
        </Link>
      </div>
    </nav>
  )
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="bg-black text-white">
        <Nav />
        {children}
        <Analytics />
      </body>
    </html>
  )
}
