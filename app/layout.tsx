import './globals.css';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Offset Lab',
  description: 'Precision fitment. No guesswork.',
  icons: {
    icon: '/logos/offset-lab-app-icon.png',
    apple: '/logos/offset-lab-app-icon.png',
  },
  openGraph: {
    title: 'Offset Lab',
    description: 'Precision fitment. No guesswork.',
    images: ['/logos/offset-lab-primary-logo.png'],
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
