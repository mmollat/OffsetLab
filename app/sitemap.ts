import type { MetadataRoute } from "next";

const siteUrl = "https://offset-lab.com";

const routes = ["", "/fitment", "/compare", "/torque", "/gallery", "/builds"];

export default function sitemap(): MetadataRoute.Sitemap {
  const now = new Date();

  return routes.map((route) => ({
    url: `${siteUrl}${route}`,
    lastModified: now,
    changeFrequency: route === "" ? "weekly" : "daily",
    priority: route === "" ? 1 : 0.8,
  }));
}
