# Project Aether

A single-screen Flutter app that manages a live "World Event" and a high-frequency engagement layer for a global MMORPG.

## The Firebase Bill (Cost & Sharding)

**If 10,000 players are chatting in the engagement box at once, how would you structure the Firebase queries to avoid a massive 'Read' cost bill?**

To avoid massive 'Read' costs from 10,000 concurrent chatters, I would avoid having clients listen to a global, unbounded chat collection where every new message triggers 10,000 document reads. Instead, I would use a Cloud Function or a backend worker to aggregate incoming messages into a single, rolling "recent_messages" document that updates at a controlled interval (e.g., every 1 second). Clients would only listen to this single aggregated document, drastically reducing the read multiplier and keeping costs predictable while maintaining a "live" feel.
