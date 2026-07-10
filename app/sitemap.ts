import type { MetadataRoute } from "next";
import { getFitmentSeoPages } from "./lib/getFitmentSeoPages";
import { getVerifiedTorqueSeoPages } from "./lib/getVerifiedTorqueSeoPages";

const siteUrl = "https://offset-lab.com";

const routes = ["", "/fitment", "/compare", "/torque", "/gallery", "/builds"];

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const now = new Date();
  const [fitmentPages, torquePages] = await Promise.all([
    getFitmentSeoPages(),
    getVerifiedTorqueSeoPages(),
  ]);

  const staticRoutes = routes.map((route) => ({
    url: `${siteUrl}${route}`,
    lastModified: now,
    changeFrequency: (route === "" ? "weekly" : "daily") as "weekly" | "daily",
    priority: route === "" ? 1 : 0.8,
  }));

  const torqueRoutes = torquePages.map((page) => ({
    url: `${siteUrl}${page.urlPath}`,
    lastModified: now,
    changeFrequency: "weekly" as const,
    priority: 0.72,
  }));

  const fitmentRoutes = fitmentPages.map((page) => ({
    url: `${siteUrl}${page.urlPath}`,
    lastModified: now,
    changeFrequency: "weekly" as const,
    priority: 0.74,
  }));

  return [...staticRoutes, ...fitmentRoutes, ...torqueRoutes];
}
