# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveConstellation::Helpers::Constants do
  describe 'SPECTRAL_CLASSES' do
    it 'has 7 classes from O to M' do
      expect(described_class::SPECTRAL_CLASSES).to eq(%i[O B A F G K M])
    end

    it 'is frozen' do
      expect(described_class::SPECTRAL_CLASSES).to be_frozen
    end
  end

  describe 'PATTERN_TYPES' do
    it 'includes standard patterns' do
      %i[linear circular spiral cluster].each do |p|
        expect(described_class::PATTERN_TYPES).to include(p)
      end
    end
  end

  describe '.label_for' do
    it 'returns supergiant for high magnitude' do
      expect(described_class.label_for(described_class::MAGNITUDE_LABELS, 0.9)).to eq(:supergiant)
    end

    it 'returns brown_dwarf for low magnitude' do
      expect(described_class.label_for(described_class::MAGNITUDE_LABELS, 0.1)).to eq(:brown_dwarf)
    end

    it 'returns ancient for high maturity' do
      expect(described_class.label_for(described_class::MATURITY_LABELS, 0.85)).to eq(:ancient)
    end
  end
end
