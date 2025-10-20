# ===========================
#  Base: Node 22 (Debian slim)
# ===========================
FROM node:22-slim

# ---------------------------
# 1. System setup
# ---------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl bash git dos2unix ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# ---------------------------
# 2. Copy build script
# ---------------------------
WORKDIR /code
COPY ./compile_page.sh ./compile_page.sh
RUN dos2unix ./compile_page.sh && chmod +x ./compile_page.sh

# ---------------------------
# 3. Prepare Next.js workspace
# ---------------------------
WORKDIR /home/user/app
ENV NEXT_TELEMETRY_DISABLED=1
ENV CI=true

# Create base Next.js app (TypeScript + ESLint)
RUN npx --yes create-next-app@latest . --ts --eslint --no-tailwind --yes

# ---------------------------
# 4. Install UI & animation deps
# ---------------------------
RUN npm install --yes \
    tailwindcss postcss autoprefixer \
    clsx tailwind-merge lucide-react \
    shadcn-ui class-variance-authority radix-ui react-hook-form zod @hookform/resolvers \
    framer-motion gsap lenis locomotive-scroll \
    @react-three/fiber @react-three/drei three motion \
    next-themes @vercel/analytics @vercel/speed-insights

# ---------------------------
# 5. Init Tailwind & basic ShadCN setup (non-blocking)
# ---------------------------
RUN npx --yes tailwindcss init -p || true

# manually create minimal tailwind.config.js if missing
RUN [ -f tailwind.config.js ] || echo 'module.exports = { content: ["./app/**/*.{ts,tsx}"], theme: { extend: {} }, plugins: [] }' > tailwind.config.js

# ---------------------------
# 6. Auto-add "use client" to hook-based files (for generated code)
# ---------------------------
RUN find app -type f -name "*.tsx" -exec grep -lE "use(State|Effect|Ref|Callback|Memo)" {} \; | \
    while read -r f; do \
      if ! grep -q '"use client";' "$f"; then \
        sed -i '1i"use client";' "$f"; \
      fi; \
    done || true

# ---------------------------
# 7. Flatten project & cleanup
# ---------------------------
RUN cp -r /home/user/app/. /home/user/ && rm -rf /home/user/app

# ---------------------------
# 8. Set final working dir & entry
# ---------------------------
WORKDIR /home/user
ENTRYPOINT ["bash", "/code/compile_page.sh"]
