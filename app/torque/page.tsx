import {
  getVerifiedTorqueSeoPages,
  VerifiedTorqueSeoPage,
} from "../lib/getVerifiedTorqueSeoPages";
import TorqueLookupClient, { VerifiedTorqueLink } from "./TorqueLookupClient";

export const revalidate = 86400;

function formatTorquePageCard(page: VerifiedTorqueSeoPage): VerifiedTorqueLink {
  const primarySpec = page.specs.find((spec) => spec.categorySlug === "wheels") ?? page.specs[0];
  const ftLb =
    primarySpec?.torqueFtLb !== null && primarySpec?.torqueFtLb !== undefined
      ? `${primarySpec.torqueFtLb} ft-lb`
      : null;
  const nm =
    primarySpec?.torqueNm !== null && primarySpec?.torqueNm !== undefined
      ? `${primarySpec.torqueNm} Nm`
      : null;

  return {
    title: `${page.makeName} ${page.generationName} ${primarySpec?.fastener ?? "torque"}`,
    spec: [ftLb, nm].filter(Boolean).join(" / ") || "Verified spec",
    href: page.urlPath,
  };
}

async function getVerifiedTorqueLinks() {
  const pages = await getVerifiedTorqueSeoPages();
  const prioritySlugs = [
    "6th-gen-4runner",
    "alpha2-ct4-v-ct5-v-blackwing",
    "zn8-zd8-brz",
  ];

  return [...pages]
    .sort((a, b) => {
      const aPriority = prioritySlugs.indexOf(a.generationSlug);
      const bPriority = prioritySlugs.indexOf(b.generationSlug);

      if (aPriority !== -1 || bPriority !== -1) {
        return (aPriority === -1 ? 99 : aPriority) - (bPriority === -1 ? 99 : bPriority);
      }

      return `${a.makeName} ${a.generationName}`.localeCompare(
        `${b.makeName} ${b.generationName}`
      );
    })
    .slice(0, 6)
    .map(formatTorquePageCard);
}

export default async function TorquePage() {
  const verifiedTorqueLinks = await getVerifiedTorqueLinks();

  return <TorqueLookupClient verifiedTorqueLinks={verifiedTorqueLinks} />;
}
