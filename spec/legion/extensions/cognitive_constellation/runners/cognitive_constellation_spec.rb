# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveConstellation::Runners::CognitiveConstellation do
  let(:engine) { Legion::Extensions::CognitiveConstellation::Helpers::SkyEngine.new }

  describe '.discover_star' do
    it 'returns success with star hash' do
      result = described_class.discover_star(
        name: 'Vega', domain: :memory, content: 'bright star', engine: engine
      )
      expect(result[:success]).to be true
      expect(result[:star][:name]).to eq('Vega')
    end

    it 'returns failure for invalid domain' do
      result = described_class.discover_star(
        name: 'x', domain: :antimatter, content: 'y', engine: engine
      )
      expect(result[:success]).to be false
      expect(result[:error]).to match(/unknown domain/)
    end
  end

  describe '.form_constellation' do
    it 'returns success' do
      result = described_class.form_constellation(
        name: 'Orion', pattern_type: :linear, engine: engine
      )
      expect(result[:success]).to be true
      expect(result[:constellation][:name]).to eq('Orion')
    end

    it 'returns failure for invalid pattern' do
      result = described_class.form_constellation(
        name: 'x', pattern_type: :zigzag, engine: engine
      )
      expect(result[:success]).to be false
    end
  end

  describe '.navigate' do
    it 'returns connected stars in target domain' do
      s1 = engine.discover_star(name: 'A', domain: :reasoning, content: 'start')
      s2 = engine.discover_star(name: 'B', domain: :memory, content: 'end')
      engine.form_constellation(name: 'Path', pattern_type: :arc,
                                star_ids: [s1.id, s2.id])
      result = described_class.navigate(
        from_star_id: s1.id, target_domain: :memory, engine: engine
      )
      expect(result[:success]).to be true
      expect(result[:count]).to eq(1)
    end
  end

  describe '.list_stars' do
    it 'returns all stars' do
      engine.discover_star(name: 'a', domain: :logic, content: 'x')
      engine.discover_star(name: 'b', domain: :memory, content: 'y')
      result = described_class.list_stars(engine: engine)
      expect(result[:count]).to eq(2)
    end

    it 'filters by domain' do
      engine.discover_star(name: 'a', domain: :logic, content: 'x')
      engine.discover_star(name: 'b', domain: :memory, content: 'y')
      result = described_class.list_stars(engine: engine, domain: :logic)
      expect(result[:count]).to eq(1)
    end
  end

  describe '.list_constellations' do
    it 'returns all constellations' do
      engine.form_constellation(name: 'Orion', pattern_type: :linear)
      result = described_class.list_constellations(engine: engine)
      expect(result[:count]).to eq(1)
    end
  end

  describe '.sky_status' do
    it 'returns a report' do
      result = described_class.sky_status(engine: engine)
      expect(result[:success]).to be true
      expect(result[:report]).to have_key(:total_stars)
    end
  end
end
