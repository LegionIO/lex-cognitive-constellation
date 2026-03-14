# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveConstellation::Helpers::Constellation do
  subject(:constellation) do
    described_class.new(name: 'Orion', pattern_type: :linear)
  end

  describe '#initialize' do
    it 'sets name' do
      expect(constellation.name).to eq('Orion')
    end

    it 'sets pattern type' do
      expect(constellation.pattern_type).to eq(:linear)
    end

    it 'generates uuid' do
      expect(constellation.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'starts empty' do
      expect(constellation.empty?).to be true
    end

    it 'defaults maturity to 0.1' do
      expect(constellation.maturity).to eq(0.1)
    end

    it 'rejects unknown pattern type' do
      expect { described_class.new(name: 'x', pattern_type: :zigzag) }
        .to raise_error(ArgumentError, /unknown pattern type/)
    end
  end

  describe '#add_star' do
    it 'adds a star id' do
      constellation.add_star('s1')
      expect(constellation.star_ids).to include('s1')
    end

    it 'increases maturity' do
      old = constellation.maturity
      constellation.add_star('s1')
      expect(constellation.maturity).to be > old
    end

    it 'returns false for duplicates' do
      constellation.add_star('s1')
      expect(constellation.add_star('s1')).to be false
    end

    it 'returns true for new stars' do
      expect(constellation.add_star('s1')).to be true
    end
  end

  describe '#remove_star' do
    it 'removes a star id' do
      constellation.add_star('s1')
      constellation.remove_star('s1')
      expect(constellation.star_ids).not_to include('s1')
    end

    it 'decreases maturity' do
      constellation.add_star('s1')
      old = constellation.maturity
      constellation.remove_star('s1')
      expect(constellation.maturity).to be < old
    end

    it 'returns false if not present' do
      expect(constellation.remove_star('nope')).to be false
    end
  end

  describe '#size' do
    it 'counts stars' do
      constellation.add_star('s1')
      constellation.add_star('s2')
      expect(constellation.size).to eq(2)
    end
  end

  describe '#ancient?' do
    it 'returns false when nascent' do
      expect(constellation.ancient?).to be false
    end

    it 'returns true at high maturity' do
      c = described_class.new(name: 'old', pattern_type: :cluster, maturity: 0.9)
      expect(c.ancient?).to be true
    end
  end

  describe '#nascent?' do
    it 'returns true initially' do
      expect(constellation.nascent?).to be true
    end
  end

  describe '#maturity_label' do
    it 'returns a symbol' do
      expect(constellation.maturity_label).to be_a(Symbol)
    end
  end

  describe '#to_h' do
    it 'returns all keys' do
      h = constellation.to_h
      %i[id name pattern_type star_ids size maturity maturity_label
         formed_at ancient nascent].each do |k|
        expect(h).to have_key(k)
      end
    end
  end
end
