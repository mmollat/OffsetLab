import SiteHeader from "./components/SiteHeader";
import type { ReactNode } from "react";

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html>
      <body style={{ background: "#000", color: "#fff" }}>
        <SiteHeader />
        {children}
      </body>
    </html>
  );
}
