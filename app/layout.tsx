import './globals.css';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Offset Lab',
  description: 'Precision fitment. No guesswork.',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
