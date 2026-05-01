import './globals.css'
import type { Metadata } from 'next'
import { Analytics } from '@vercel/analytics/react'

export const metadata: Metadata = {
  title: 'Offset Lab',
  description: 'Precision fitment tool',
}

function Nav() {
  return (
    <nav className="w-full border-b border-neutral-800 px-6 py-4 flex items-center justify-between">
      <div className="text-white font-semibold tracking-wide">
        OFFSET LAB
      </div>

      <div className="flex gap-6 text-sm text-neutral-400">
        <a href="/" className="hover:text-white transition">Home</a>
        <a href="/gallery" className="hover:text-white transition">Gallery</a>
        <a href="/submit" className="hover:text-white transition">Submit</a>
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
