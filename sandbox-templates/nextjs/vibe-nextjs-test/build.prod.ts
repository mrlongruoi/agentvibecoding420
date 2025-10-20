import { Template, defaultBuildLogger } from '@e2b/sdk'
import { template } from './template'

async function main() {
  await Template.build(template, {
    alias: 'vibe-nextjs-test-ai',
    onBuildLogs: defaultBuildLogger(),
  });
}

main().catch(console.error);