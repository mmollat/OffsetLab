
import SiteHeader from "./components/SiteHeader";

export default function RootLayout({ children }) {
  return (
    <html>
      <body style={{background:"#000", color:"#fff"}}>
        <SiteHeader />
        {children}
      </body>
    </html>
  );
}
