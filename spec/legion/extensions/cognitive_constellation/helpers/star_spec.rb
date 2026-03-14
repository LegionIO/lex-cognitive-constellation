# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveConstellation::Helpers::Star do
  subject(:star) do
    described_class.new(name: 'Polaris', domain: :reasoning, content: 'north star concept')
  end

  describe '#initialize' do
    it 'sets name' do
      expect(star.name).to eq('Polaris')
    end

    it 'sets domain' do
      expect(star.domain).to eq(:reasoning)
    end

    it 'generates uuid' do
      expect(star.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'defaults magnitude to 0.5' do
      expect(star.magnitude).to eq(0.5)
    end

    it 'assigns a spectral class' do
      expect(Legion::Extensions::CognitiveConstellation::Helpers::Constants::SPECTRAL_CLASSES)
        .to include(star.spectral_class)
    end

    it 'starts with no constellations' do
      expect(star.constellation_ids).to be_empty
    end

    it 'rejects unknown domain' do
      expect { described_class.new(name: 'x', domain: :antimatter, content: 'y') }
        .to raise_error(ArgumentError, /unknown domain/)
    end

    it 'accepts custom magnitude' do
      s = described_class.new(name: 'Sirius', domain: :memory, content: 'x', magnitude: 0.9)
      expect(s.magnitude).to eq(0.9)
    end

    it 'clamps magnitude' do
      s = described_class.new(name: 'x', domain: :logic, content: 'y', magnitude: 5.0)
      expect(s.magnitude).to eq(1.0)
    end
  end

  describe '#dim!' do
    it 'decreases magnitude' do
      old = star.magnitude
      star.dim!
      expect(star.magnitude).to be < old
    end

    it 'does not go below zero' do
      100.times { star.dim!(rate: 0.5) }
      expect(star.magnitude).to eq(0.0)
    end
  end

  describe '#brighten!' do
    it 'increases magnitude' do
      old = star.magnitude
      star.brighten!
      expect(star.magnitude).to be > old
    end

    it 'does not exceed 1.0' do
      20.times { star.brighten!(boost: 0.5) }
      expect(star.magnitude).to eq(1.0)
    end
  end

  describe '#supergiant?' do
    it 'returns false at default magnitude' do
      expect(star.supergiant?).to be false
    end

    it 'returns true at high magnitude' do
      star.brighten!(boost: 0.4)
      expect(star.supergiant?).to be true
    end
  end

  describe '#fading?' do
    it 'returns false at default magnitude' do
      expect(star.fading?).to be false
    end

    it 'returns true after heavy dimming' do
      10.times { star.dim!(rate: 0.1) }
      expect(star.fading?).to be true
    end
  end

  describe '#join_constellation' do
    it 'adds constellation id' do
      star.join_constellation('c1')
      expect(star.constellation_ids).to include('c1')
    end

    it 'does not duplicate' do
      star.join_constellation('c1')
      star.join_constellation('c1')
      expect(star.constellation_ids.size).to eq(1)
    end
  end

  describe '#magnitude_label' do
    it 'returns a symbol' do
      expect(star.magnitude_label).to be_a(Symbol)
    end
  end

  describe '#to_h' do
    it 'returns all keys' do
      h = star.to_h
      %i[id name domain content spectral_class magnitude magnitude_label
         discovered_at constellation_ids supergiant fading].each do |k|
        expect(h).to have_key(k)
      end
    end
  end
end
