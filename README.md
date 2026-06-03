# Offset Lab

Offset Lab is an automotive fitment and torque-spec tool built with Next.js,
TypeScript, Tailwind CSS, and Supabase.

The app helps enthusiasts compare wheel, tire, offset, stance, and clearance
options across supported vehicle platforms. It also includes community build
submissions, a fitment gallery, and TorqueHub for fast torque-spec lookup.

## Included

- Homepage / entry screen
- Fitment recommendation flow
- Compare setup page
- Community builds page
- Verified fitment gallery
- TorqueHub torque-spec lookup
- OEM+, Flush, and Aggressive fitment presets
- Square and staggered setup recommendations
- Street and track-oriented recommendation overrides
- Poke, inner-clearance, track-width, and tire-diameter calculations
- Supabase-backed vehicle, fitment, gallery, build, and torque-spec data

## Tech Stack

- Next.js 14
- React 18
- TypeScript
- Tailwind CSS
- Supabase
- Vercel Analytics

## Environment Variables

Create a `.env.local` file with:

```bash
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
```

## Run locally

```bash
npm install
npm run dev
```

Then open `http://localhost:3000`.

## Notes

- Supabase is the source of truth for live fitment, vehicle, build, and torque data.
- Local fitment exports are retained as compatibility shims during the data migration.
- Data should be verified before public launch.
- Recommendation logic is enthusiast-first, not purely conservative.
