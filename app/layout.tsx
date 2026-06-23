import './globals.css'
import type { Metadata } from 'next'
import { Analytics } from '@vercel/analytics/react'
import SiteNav from './components/SiteNav'

export const metadata: Metadata = {
  metadataBase: new URL('https://offset-lab.com'),
  title: {
    default: 'Offset Lab',
    template: '%s | Offset Lab',
  },
  description:
    'Vehicle-specific wheel, tire, offset, torque, and fitment tools for dialing in your setup with less guesswork.',
  alternates: {
    canonical: '/',
  },
  openGraph: {
    title: 'Offset Lab',
    description:
      'Vehicle-specific wheel, tire, offset, torque, and fitment tools for dialing in your setup with less guesswork.',
    url: '/',
    siteName: 'Offset Lab',
    type: 'website',
  },
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
