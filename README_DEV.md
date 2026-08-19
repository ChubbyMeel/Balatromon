# Balatromon generated source

This is a first full implementation pass generated from the supplied Balatromon design database.

## Included

- 131 Digimon Joker registrations.
- Every listed Joker effect has an implementation handler.
- Universal Hunger/Bond/Care Mistake progression.
- Hunger starts at 1, Bond at 0, Care Mistakes at 0.
- Hunger rises by 1 every two rounds.
- Hunger > 3 gives one Care Mistake per round and blocks Bond gain.
- Hunger 5 permanently debuffs/disables the Digimon.
- Bond rises by one per round when Hunger is 3 or lower.
- Care Mistakes cap at 3 and set `care_crisis`; the later Digivice system should resolve the bad-path/de-Digivolution.
- Shop Joker pool is replaced only for normal shop rolls (`sho`/`shop`) so vanilla Jokers do not appear there.
- Shop weights: Fresh 12, In-Training 12, Rookie 10, Champion 1, special Rare 1. Ultimate/Mega are not in normal shop pool.
- Evolution destinations are stored on each Joker for the later Digivice implementation.

## Naming cleanup

The database now uses consistent names such as MetalGreymon, SkullGreymon, WarGreymon, BlackWarGreymon, WarGrowlmon, WereGarurumon, LoaderLeomon, MetalGarurumon, HeavyLeomon, WaruMonzaemon, PolarBearmon, MarineBullmon, MetalSeadramon, YukimiBotamon, DemiDevimon, DemiVeemon, ExVeemon, ZubaEagermon, HoverEspimon, and readable Imperialdramon mode names. Evolution references were updated to the same names without changing the graph. Monzaemon, WaruMonzaemon and PolarBearmon were corrected to Ultimate stage.

## Artwork

All Jokers currently point at `DigiMeel_Joker.png` and `{x=0,y=0}` so the code can be developed before the full atlas is assigned. The cleaned CSV includes Atlas X/Y columns for later.

## Advanced effects worth testing first

Several effects touch unusual Balatro systems and should be tested in-game early: probability modifiers, copying/retriggering other Jokers, straight-gap rules, suit equivalence, held-card seal activation, and shop-pool replacement. The code uses current SMODS contexts/helpers for these, but Balatro mod interactions can expose edge cases.

Gallantmon's effect relies on `card.ability.extra.previous_form_value`; the Digivice/evolution replacement code should set that snapshot when a Digimon evolves into Gallantmon.

A minimal Food Digi Item is included because several Joker effects create Food. The remaining Digi Items and Digivices can be implemented separately.

## Stage badges and consumables patch
- Joker badge rarity is now the Digimon stage: Fresh, In-Training, Rookie, Champion, Ultimate, Mega, or special Rare.
- Registered all Digi Items from the design database: Food, Hefty Food, PlayBall, Bandaid, Digivice, D-3, D-Ark, Digitama.
- Registered Golden D-Ark and Golden Digitama as Spectral consumables.
- All item art temporarily points to the existing `Joker` atlas at `{x=0,y=0}`.
- Branching Digivolution remains protected: Digivices will only auto-transform a full-Bond Digimon when its database entry has exactly one next form. This avoids silently choosing the wrong branch before branch-routing conditions are encoded.

## Branching Digivolution UI (0.2.1)
- `src/evolution.lua` owns Digivolution routing and the interactive branch picker.
- One viable route: evolves immediately.
- Multiple viable routes: opens a Balatro overlay showing each form as a hoverable Joker preview plus a DIGIVOLVE button.
- D-3 processes its random Digimon sequentially; if more than one of them branches, the choice panels appear one after another.
- Current default: every connected evolution listed in `balatromon_evolves_to` is viable once Bond is full.
- Future route restrictions belong in `Balatromon.evolution_rules`, not inside the 131 Joker definitions.

Example future restriction:
```lua
Balatromon.evolution_rules.agumon = {
    greymon = {max_care = 1},
    numemon = {min_care = 2},
}
```


## Evolution routing rules (0.3.0)
- Added explicit rules for every branching Digimon in the current 131-Joker database.
- Ordinary Digivolution still requires full Bond.
- Standard routes are always available outside a Care Crisis; Hunger and Care Mistakes unlock additional alternate routes.
- D-3 unlocks the Armor routes for Patamon -> Pegasusmon, Salamon -> Nefertimon, Veemon -> Flamedramon, and Hawkmon -> Halsemon.
- At 3 Care Mistakes, normal routes are suppressed. Marked bad paths take priority.
- If no bad path exists, a compatible Digivice De-Digivolves the Digimon to its Fresh form. Personal evolution history is preferred; shop-obtained forms fall back to reachable Fresh ancestors. Standalone high-stage forms with no incoming line use one deterministic random Fresh form as an emergency reset.
- Resolving a Care Crisis resets Care Mistakes to 0 while preserving Hunger.
- The branch chooser now lays out at most three forms per row and displays a short route requirement under each form.
- See `EVOLUTION_RULES.md` for the full 44-source branch table.

## v0.3.3 additions

- `src/boosters.lua`: Digimon-only Buffoon Packs + Digital Packs containing Digi Items.
- `src/tarot_revisions.lua`: revised Judgement, The Emperor, and The Fool.
- Scaling Jokers now show their live accumulated Mult/Chips/XMult/XChips in their tooltip; Kyubimon shows its current payout.
- `BM.set_enhancement` now juices cards when a Digimon changes their enhancement.
