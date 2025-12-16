Travel concierge Architecture

┌──────────────────────────┐
│        User Device       │
│  (Seatback / Mobile App) │
│                          │
│  "Plan 3-day Tokyo trip" │
└───────────┬──────────────┘
            │
            │ ① Compressed, Intent-based Request
            │    (JSON, short tokens, retry-safe)
            ▼
┌──────────────────────────┐
│     Aircraft Gateway     │
│  - Request normalizer    │
│  - Compression (gzip)    │
│  - Idempotency key       │
└───────────┬──────────────┘
            │
            │ ② Secure API Call (HTTPS / gRPC)
            │    Optimized for high latency
            ▼
┌──────────────────────────┐
│       LEO Satellite      │
│   (Starlink / OneWeb)    │
│  - High latency tolerant │
│  - Intermittent links    │
└───────────┬──────────────┘
            │
            │ ③ Downlink
            ▼
┌──────────────────────────┐
│   Ground Edge Ingress    │
│  (Closest PoP / Region)  │
│  - Rate limiting         │
│  - Auth / validation    │
└───────────┬──────────────┘
            │
            │
            ▼
┌───────────────────────────────────────────┐
│        Travel Concierge Backend            │
│                                           │
│  ┌──────────────┐     ┌───────────────┐  │
│  │ Request      │     │ Cache Layer   │  │
│  │ Orchestrator │────▶│ (Redis / KV)  │  │
│  │              │◀────│ Query+Resp    │  │
│  └──────┬───────┘     └───────────────┘  │
│         │                                  │
│   Cache │ Miss                             │
│         ▼                                  │
│  ┌──────────────────────────┐             │
│  │ Prompt Builder / Agent   │             │
│  │ - System prompt          │             │
│  │ - User intent            │             │
│  │ - Constraints            │             │
│  └───────────┬──────────────┘             │
│              │                              │
│              ▼                              │
│      ┌──────────────────┐                 │
│      │   ChatGPT / LLM   │                 │
│      │ (Itinerary Gen)   │                 │
│      └──────────────────┘                 │
│              │                              │
│              ▼                              │
│  ┌──────────────────────────┐             │
│  │ Post-Processor           │             │
│  │ - Shorten response       │             │
│  │ - Structured JSON        │             │
│  └───────────┬──────────────┘             │
│              │                              │
│              ▼                              │
│      Cache Response (TTL)                  │
└───────────┬──────────────────────────────┘
            │
            │ ④ Response (compressed, chunked)
            ▼
┌──────────────────────────┐
│       LEO Satellite      │
└───────────┬──────────────┘
            │
            ▼
┌──────────────────────────┐
│   Aircraft Gateway       │
│  - Decompress            │
│  - Resume partial fetch │
└───────────┬──────────────┘
            │
            ▼
┌──────────────────────────┐
│        User Device       │
│  "Here’s your itinerary" │
└──────────────────────────┘


