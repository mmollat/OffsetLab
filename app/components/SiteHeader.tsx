
import Link from "next/link";

export default function SiteHeader() {
  return (
    <header style={{padding:20, borderBottom:"1px solid #222"}}>
      <Link href="/">Offset Lab</Link>
    </header>
  );
}
