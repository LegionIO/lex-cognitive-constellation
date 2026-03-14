# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveConstellation
      module Helpers
        class Constellation
          attr_reader :id, :name, :pattern_type, :star_ids,
                      :formed_at
          attr_accessor :maturity

          def initialize(name:, pattern_type:, maturity: nil)
            validate_pattern!(pattern_type)
            @id           = SecureRandom.uuid
            @name         = name.to_s
            @pattern_type = pattern_type.to_sym
            @star_ids     = []
            @maturity     = (maturity || 0.1).to_f.clamp(0.0, 1.0).round(10)
            @formed_at    = Time.now.utc
          end

          def add_star(star_id)
            return false if @star_ids.include?(star_id)

            @star_ids << star_id
            @maturity = (@maturity + 0.05).clamp(0.0, 1.0).round(10)
            true
          end

          def remove_star(star_id)
            return false unless @star_ids.include?(star_id)

            @star_ids.delete(star_id)
            @maturity = (@maturity - 0.05).clamp(0.0, 1.0).round(10)
            true
          end

          def size
            @star_ids.size
          end

          def empty?
            @star_ids.empty?
          end

          def ancient?
            @maturity >= 0.8
          end

          def nascent?
            @maturity < 0.2
          end

          def maturity_label
            Constants.label_for(Constants::MATURITY_LABELS, @maturity)
          end

          def to_h
            {
              id:             @id,
              name:           @name,
              pattern_type:   @pattern_type,
              star_ids:       @star_ids.dup,
              size:           size,
              maturity:       @maturity,
              maturity_label: maturity_label,
              formed_at:      @formed_at,
              ancient:        ancient?,
              nascent:        nascent?
            }
          end

          private

          def validate_pattern!(val)
            return if Constants::PATTERN_TYPES.include?(val.to_sym)

            raise ArgumentError,
                  "unknown pattern type: #{val.inspect}; " \
                  "must be one of #{Constants::PATTERN_TYPES.inspect}"
          end
        end
      end
    end
  end
end
