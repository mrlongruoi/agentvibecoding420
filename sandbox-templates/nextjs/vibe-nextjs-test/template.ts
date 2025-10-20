import { Template } from "@e2b/sdk"

// Type assertion as temporary fix
export const template = new (Template as any )({
  name: "vibe-nextjs-test",
  runtime: "node",
  entrypoint: "index.js",
})