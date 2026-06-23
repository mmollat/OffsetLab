import { request } from "node:https";

const baseUrl = (process.env.AUDIT_BASE_URL || "https://offset-lab.com").replace(/\/$/, "");
const routes = ["/", "/fitment", "/compare", "/torque", "/gallery", "/builds"];
const requiredSitemapRoutes = ["", "/fitment", "/compare", "/torque", "/gallery"];
const timeoutMs = Number(process.env.AUDIT_TIMEOUT_MS || 15000);

function fetchText(url) {
  return new Promise((resolve, reject) => {
    const req = request(
      url,
      {
        method: "GET",
        headers: {
          "user-agent": "OffsetLabAudit/1.0",
          accept: "text/html,application/xml,text/plain,*/*",
        },
      },
      (res) => {
        let body = "";
        res.setEncoding("utf8");
        res.on("data", (chunk) => {
          body += chunk;
        });
        res.on("end", () => {
          resolve({
            body,
            headers: res.headers,
            statusCode: res.statusCode ?? 0,
            url,
          });
        });
      }
    );

    req.setTimeout(timeoutMs, () => {
      req.destroy(new Error(`Timed out after ${timeoutMs}ms`));
    });
    req.on("error", reject);
    req.end();
  });
}

function assertOk(condition, message, failures) {
  if (!condition) failures.push(message);
}

function getTag(html, tagName) {
  const match = html.match(new RegExp(`<${tagName}[^>]*>([\\s\\S]*?)<\\/${tagName}>`, "i"));
  return match?.[1]?.replace(/\s+/g, " ").trim() ?? "";
}

function getMetaDescription(html) {
  const match =
    html.match(/<meta[^>]+name=["']description["'][^>]+content=["']([^"']+)["'][^>]*>/i) ??
    html.match(/<meta[^>]+content=["']([^"']+)["'][^>]+name=["']description["'][^>]*>/i);
  return match?.[1] ?? "";
}

function getCanonical(html) {
  const match =
    html.match(/<link[^>]+rel=["']canonical["'][^>]+href=["']([^"']+)["'][^>]*>/i) ??
    html.match(/<link[^>]+href=["']([^"']+)["'][^>]+rel=["']canonical["'][^>]*>/i);
  return match?.[1] ?? "";
}

async function main() {
  const failures = [];
  const routeResults = [];

  for (const route of routes) {
    const result = await fetchText(`${baseUrl}${route}`);
    routeResults.push({
      route,
      statusCode: result.statusCode,
      contentType: result.headers["content-type"] ?? "",
    });
    assertOk(result.statusCode >= 200 && result.statusCode < 400, `${route} returned ${result.statusCode}`, failures);
  }

  const home = await fetchText(`${baseUrl}/`);
  const title = getTag(home.body, "title");
  const description = getMetaDescription(home.body);
  const canonical = getCanonical(home.body);

  assertOk(title.includes("Offset Lab"), `Homepage title missing Offset Lab: "${title}"`, failures);
  assertOk(description.length >= 50, "Homepage meta description is missing or too short", failures);
  assertOk(
    canonical === baseUrl || canonical === `${baseUrl}/` || canonical === "/",
    `Homepage canonical missing or unexpected: "${canonical}"`,
    failures
  );

  const robots = await fetchText(`${baseUrl}/robots.txt`);
  assertOk(robots.statusCode === 200, `/robots.txt returned ${robots.statusCode}`, failures);
  assertOk(/sitemap:\s*https:\/\/offset-lab\.com\/sitemap\.xml/i.test(robots.body), "robots.txt does not reference sitemap.xml", failures);

  const sitemap = await fetchText(`${baseUrl}/sitemap.xml`);
  assertOk(sitemap.statusCode === 200, `/sitemap.xml returned ${sitemap.statusCode}`, failures);
  for (const route of requiredSitemapRoutes) {
    assertOk(
      sitemap.body.includes(`${baseUrl}${route}`),
      `sitemap.xml does not include ${baseUrl}${route}`,
      failures
    );
  }

  const report = {
    baseUrl,
    checkedAt: new Date().toISOString(),
    routeResults,
    metadata: {
      title,
      description,
      canonical,
    },
    failures,
  };

  console.log(JSON.stringify(report, null, 2));

  if (failures.length > 0) {
    process.exitCode = 1;
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
