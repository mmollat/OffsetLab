import './globals.css'
import type { Metadata } from 'next'
import { Analytics } from '@vercel/analytics/react'
import SiteNav from './components/SiteNav'

export const metadata: Metadata = {
  title: 'Offset Lab',
  description: 'Precision fitment tool',
  icons: {
    icon: '/logos/offset-lab-app-icon.png',
    shortcut: '/logos/offset-lab-app-icon.png',
    apple: '/logos/offset-lab-app-icon.png',
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="bg-black text-white">
        <SiteNav />
        {children}
        <Analytics />
      </body>
    </html>
  )
}
