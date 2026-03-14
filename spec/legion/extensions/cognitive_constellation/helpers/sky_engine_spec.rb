# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveConstellation::Helpers::SkyEngine do
  subject(:engine) { described_class.new }

  let(:star) do
    engine.discover_star(name: 'Polaris', domain: :reasoning, content: 'north concept')
  end

  describe '#discover_star' do
    it 'creates and stores a star' do
      s = engine.discover_star(name: 'Vega', domain: :memory, content: 'bright')
      expect(s).to be_a(Legion::Extensions::CognitiveConstellation::Helpers::Star)
    end

    it 'raises when catalog is full' do
      stub_const('Legion::Extensions::CognitiveConstellation::Helpers::Constants::MAX_STARS', 1)
      engine.discover_star(name: 'a', domain: :logic, content: 'x')
      expect { engine.discover_star(name: 'b', domain: :logic, content: 'y') }
        .to raise_error(ArgumentError, /sky catalog full/)
    end
  end

  describe '#form_constellation' do
    it 'creates a constellation' do
      con = engine.form_constellation(name: 'Orion', pattern_type: :linear)
      expect(con).to be_a(Legion::Extensions::CognitiveConstellation::Helpers::Constellation)
    end

    it 'links provided star ids' do
      star
      con = engine.form_constellation(name: 'Belt', pattern_type: :linear,
                                      star_ids: [star.id])
      expect(con.star_ids).to include(star.id)
    end

    it 'raises when too many constellations' do
      stub_const('Legion::Extensions::CognitiveConstellation::Helpers::Constants::MAX_CONSTELLATIONS', 0)
      expect { engine.form_constellation(name: 'x', pattern_type: :cluster) }
        .to raise_error(ArgumentError, /too many constellations/)
    end
  end

  describe '#link_star' do
    it 'connects star to constellation' do
      con = engine.form_constellation(name: 'Belt', pattern_type: :linear)
      engine.link_star(star_id: star.id, constellation_id: con.id)
      expect(con.star_ids).to include(star.id)
      expect(star.constellation_ids).to include(con.id)
    end
  end

  describe '#brighten_star' do
    it 'increases star magnitude' do
      old = star.magnitude
      engine.brighten_star(star_id: star.id, boost: 0.2)
      expect(star.magnitude).to be > old
    end
  end

  describe '#dim_all!' do
    it 'dims all stars' do
      star
      old = star.magnitude
      engine.dim_all!
      expect(star.magnitude).to be < old
    end

    it 'prunes stars below minimum' do
      s = engine.discover_star(name: 'faint', domain: :logic, content: 'x', magnitude: 0.01)
      engine.dim_all!(rate: 0.5)
      expect(engine.all_stars).not_to include(s)
    end
  end

  describe '#navigate' do
    it 'finds connected stars in target domain' do
      s1 = engine.discover_star(name: 'A', domain: :reasoning, content: 'start')
      s2 = engine.discover_star(name: 'B', domain: :memory, content: 'target')
      engine.form_constellation(name: 'Path', pattern_type: :arc,
                                star_ids: [s1.id, s2.id])
      results = engine.navigate(from_star_id: s1.id, target_domain: :memory)
      expect(results.map(&:id)).to include(s2.id)
    end

    it 'returns empty for unconnected domains' do
      results = engine.navigate(from_star_id: star.id, target_domain: :ethics)
      expect(results).to be_empty
    end
  end

  describe '#stars_by_domain' do
    it 'returns counts per domain' do
      star
      result = engine.stars_by_domain
      expect(result[:reasoning]).to eq(1)
    end
  end

  describe '#brightest' do
    it 'returns stars sorted by magnitude' do
      engine.discover_star(name: 'dim', domain: :logic, content: 'a', magnitude: 0.2)
      s2 = engine.discover_star(name: 'bright', domain: :logic, content: 'b', magnitude: 0.9)
      expect(engine.brightest(limit: 1).first).to eq(s2)
    end
  end

  describe '#faintest' do
    it 'returns stars sorted ascending' do
      engine.discover_star(name: 'bright', domain: :logic, content: 'a', magnitude: 0.9)
      s2 = engine.discover_star(name: 'dim', domain: :logic, content: 'b', magnitude: 0.1)
      expect(engine.faintest(limit: 1).first).to eq(s2)
    end
  end

  describe '#largest_constellations' do
    it 'returns constellations by size' do
      s1 = engine.discover_star(name: 'a', domain: :logic, content: 'x')
      s2 = engine.discover_star(name: 'b', domain: :logic, content: 'y')
      big = engine.form_constellation(name: 'big', pattern_type: :cluster,
                                      star_ids: [s1.id, s2.id])
      engine.form_constellation(name: 'small', pattern_type: :linear)
      expect(engine.largest_constellations(limit: 1).first).to eq(big)
    end
  end

  describe '#sky_report' do
    it 'returns comprehensive report' do
      star
      report = engine.sky_report
      %i[total_stars total_constellations by_domain supergiants fading avg_magnitude].each do |k|
        expect(report).to have_key(k)
      end
    end
  end
end
