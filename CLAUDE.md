# lex-cognitive-constellation

**Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Maps ideas as stars with magnitude and spectral class, groups them into constellations with pattern types, and enables celestial navigation between related concepts across cognitive domains. Provides a spatial metaphor for knowledge organization and cross-domain traversal.

## Gem Info

- **Gem name**: `lex-cognitive-constellation`
- **Version**: `0.1.0`
- **Module**: `Legion::Extensions::CognitiveConstellation`
- **Ruby**: `>= 3.4`
- **License**: MIT

## File Structure

```
lib/legion/extensions/cognitive_constellation/
  cognitive_constellation.rb
  version.rb
  client.rb
  helpers/
    constants.rb
    sky_engine.rb
    star.rb
    constellation.rb
  runners/
    cognitive_constellation.rb
```

## Key Constants

From `helpers/constants.rb`:

- `SPECTRAL_CLASSES` — `%i[O B A F G K M]` (hottest to coolest — maps to idea intensity/age)
- `PATTERN_TYPES` — `%i[linear circular spiral cluster cross arc ring scattered]`
- `DOMAINS` — `%i[reasoning memory emotion language perception action planning social creativity logic intuition ethics]`
- `MAX_STARS` = `500`, `MAX_CONSTELLATIONS` = `50`
- `MAGNITUDE_DECAY` = `0.01`, `MIN_MAGNITUDE` = `0.05`
- `MAGNITUDE_LABELS` — `0.8+` = `:supergiant`, `0.6` = `:giant`, `0.4` = `:main_sequence`, `0.2` = `:dwarf`, below = `:brown_dwarf`
- `MATURITY_LABELS` — `0.8+` = `:ancient`, `0.6` = `:established`, `0.4` = `:forming`, `0.2` = `:nascent`, below = `:proto`

## Runners

All methods in `Runners::CognitiveConstellation` (`extend self`):

- `discover_star(name:, domain:, content:, magnitude: nil, spectral_class: nil)` — registers a new concept as a star; magnitude and spectral class are optional
- `form_constellation(name:, pattern_type:, star_ids: [])` — groups stars into a named constellation with a pattern type
- `navigate(from_star_id:, target_domain:)` — finds reachable stars in the target domain starting from the source star
- `list_stars(domain: nil)` — all stars, optionally filtered by domain
- `list_constellations` — all constellations
- `sky_status` — full sky report: star count, constellation count, brightest stars, domain distribution

## Helpers

- `SkyEngine` — manages `@stars` and `@constellations`. `navigate` traverses star connections to find domain-adjacent concepts.
- `Star` — has `name`, `domain`, `content`, `magnitude`, `spectral_class`. `magnitude` decays over time if not reinforced. `magnitude_label` classifies brightness.
- `Constellation` — named grouping of star IDs with `pattern_type` and maturity score derived from number of member stars and their average magnitude.

## Integration Points

- `lex-memory` traces have domains; stars map those domains into a navigable spatial structure — cross-domain navigation via `navigate` mirrors `walk_associations` in `lex-dream`.
- `lex-cognitive-aurora` detects harmony events across domains; constellations are the structural groupings that make aurora detection meaningful (aurora fires when constellation members align).
- `MAGNITUDE_DECAY` means unused concepts fade from the sky — magnitude is an attention proxy.

## Development Notes

- `discover_star` and `form_constellation` raise `ArgumentError` on invalid inputs; runners catch these and return `{ success: false, error: e.message }`.
- `navigate` is BFS or similarity-based traversal starting from a known star, targeting a domain. The depth and algorithm are internal to `SkyEngine`.
- `spectral_class` follows the OBAFGKM Harvard classification, repurposed as an idea intensity/age proxy. `:O` = hot/young/intense; `:M` = cool/old/stable.
- Constellations do not need member stars at creation time — `star_ids: []` is valid. Stars can be added later.
