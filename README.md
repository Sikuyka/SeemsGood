# SeemsGood

Hero Collector + PvE + PvP Roblox game (original superhero satire universe).

## Quick start (Roblox Studio + Rojo)

1. Install [Rojo 7](https://rojo.space/docs/v7/getting-started/install/)
2. Install the **Rojo** plugin in Roblox Studio
3. Open a new or existing place in Studio
4. In this repo folder run:

```bash
rojo serve
```

5. In Studio: Rojo plugin → **Connect** (`localhost:34872`)
6. Press **Play** — systems load automatically

## Project layout

| Path | Role |
|------|------|
| `src/ReplicatedStorage/Shared` | Types, constants, networking |
| `src/ReplicatedStorage/Config` | Heroes, cases, NPCs, quests, skins |
| `src/ServerScriptService/Services` | Server-authoritative game logic |
| `src/ServerScriptService/Libraries/ProfileService.lua` | DataStore profiles |
| `src/StarterPlayer/StarterPlayerScripts` | Client combat, UI wiring |
| `src/StarterGui/CreateUI.client.lua` | HUD builder |
| `src/Workspace/MapSetup.server.lua` | Lobby + spawn placeholders |

## Features implemented

- **Cases:** Starter (70/20/8/2) & Premium (40/35/18/6/1 + Mythic pity)
- **Heroes:** 12 originals, levels 1–100, stat formulas, ability unlocks
- **Combat:** Light/heavy/combo, abilities, knockback, stun (server validated)
- **PvE:** Thug / Veteran / Elite / Boss waves
- **PvP:** Level-based queue & rating
- **Quests:** Daily templates + rewards
- **Retention:** Daily login, streak rewards, achievements, season XP
- **Economy:** Coins + Premium
- **Shop:** Skin registry + ProcessReceipt hook (set `ProductId` in Studio)

## Studio setup checklist

1. Enable **Game Settings → Security → Enable Studio Access to API Services** for DataStores
2. Replace `rbxassetid://0` in `AnimationStubs` / `SFXStubs` with real assets
3. Create **Developer Products** for Premium currency & map IDs in `MonetizationService.PRODUCT_MAP`
4. Map skin `ProductId` in `SkinRegistry.lua`
5. Build hero **models** in `ServerStorage` or `ReplicatedStorage` (cosmetic only; stats are server-side)

## Promo / referral

- Promo codes: `seemsgood`, `launch` → free Starter Case (server: `RetentionService`)
- Referral: extend `Flags.ReferralCode` in profile (hook in `RetentionService`)

## Controls (default)

| Input | Action |
|-------|--------|
| LMB | Light attack (combo) |
| R | Heavy attack |
| 1–4 | Skills |

## Documentation

Per-module docs: [`docs/INDEX.md`](docs/INDEX.md)

## License

Proprietary — SeemsGood studio project.
