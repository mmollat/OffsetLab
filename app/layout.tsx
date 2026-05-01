import './globals.css'
import type { Metadata } from 'next'
import Image from 'next/image'
import { Analytics } from '@vercel/analytics/react'

export const metadata: Metadata = {
  title: 'Offset Lab',
  description: 'Precision fitment tool',
}

function Nav() {
  return (
    <nav className="w-full border-b border-neutral-800 bg-black px-6 py-4 flex items-center justify-between">
      <a href="/" className="flex items-center">
        <Image
          src="/logos/offset-lab-secondary-logo.png"
          alt="Offset Lab"
          width={160}
          height={40}
          priority
        />
      </a>

      <div className="flex gap-6 text-sm text-neutral-400">
        <a href="/" className="hover:text-white transition">
          Home
        </a>
        <a href="/fitment" className="hover:text-white transition">
          Fitment
        </a>
        <a href="/gallery" className="hover:text-white transition">
          Gallery
        </a>
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
