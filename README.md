# lex-cognitive-constellation

Cognitive constellation LEX — star-mapping for concepts. Maps ideas as stars with magnitude and spectral class, groups them into constellations with pattern types, and enables celestial navigation between related concepts across cognitive domains.

## What It Does

Ideas are stars: some are supergiants (high magnitude, highly salient), others are brown dwarfs (faint, nearly forgotten). Related ideas form constellations — linear, circular, spiral, cluster, cross, arc, ring, or scattered patterns. Navigation between stars enables cross-domain traversal: starting from a known concept and finding related concepts in a target domain.

Magnitude decays over time, modeling the natural fading of unused ideas from active consideration.

## Usage

```ruby
client = Legion::Extensions::CognitiveConstellation::Client.new

star1 = client.discover_star(
  name: 'trust_anchoring',
  domain: :reasoning,
  content: 'initial trust scores anchor all subsequent assessments',
  magnitude: 0.8,
  spectral_class: :G
)

star2 = client.discover_star(
  name: 'anchoring_bias',
  domain: :reasoning,
  content: 'first information received disproportionately weights judgment',
  magnitude: 0.7
)

client.form_constellation(
  name: 'anchoring_cluster',
  pattern_type: :cluster,
  star_ids: [star1[:star][:id], star2[:star][:id]]
)

client.navigate(from_star_id: star1[:star][:id], target_domain: :emotion)
client.sky_status
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
