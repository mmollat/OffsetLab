import type { Metadata } from "next";
import "./globals.css";
import SiteHeader from "./components/SiteHeader";

export const metadata: Metadata = {
  title: "Offset Lab",
  description: "Precision fitment. No guesswork.",
  icons: {
    icon: "/logos/offset-lab-app-icon.png",
    apple: "/logos/offset-lab-app-icon.png",
  },
  openGraph: {
    title: "Offset Lab",
    description: "Precision fitment. No guesswork.",
    images: ["/logos/offset-lab-primary-logo.png"],
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="bg-black text-white antialiased">
        <SiteHeader />
        {children}
      </body>
    </html>
  );
}
