# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveConstellation
      module Helpers
        module Constants
          # Star spectral classes (hottest to coolest)
          SPECTRAL_CLASSES = %i[O B A F G K M].freeze

          # Constellation pattern types
          PATTERN_TYPES = %i[
            linear circular spiral cluster
            cross arc ring scattered
          ].freeze

          # Star domains
          DOMAINS = %i[
            reasoning memory emotion language
            perception action planning social
            creativity logic intuition ethics
          ].freeze

          MAX_STARS          = 500
          MAX_CONSTELLATIONS = 50
          MAGNITUDE_DECAY    = 0.01
          MIN_MAGNITUDE      = 0.05

          # Magnitude labels (higher = brighter = more important)
          MAGNITUDE_LABELS = [
            [(0.8..),      :supergiant],
            [(0.6...0.8),  :giant],
            [(0.4...0.6),  :main_sequence],
            [(0.2...0.4),  :dwarf],
            [(..0.2),      :brown_dwarf]
          ].freeze

          # Constellation maturity labels
          MATURITY_LABELS = [
            [(0.8..),      :ancient],
            [(0.6...0.8),  :established],
            [(0.4...0.6),  :forming],
            [(0.2...0.4),  :nascent],
            [(..0.2),      :proto]
          ].freeze

          def self.label_for(table, value)
            table.each { |range, label| return label if range.cover?(value) }
            table.last.last
          end
        end
      end
    end
  end
end
