# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveConstellation
      module Helpers
        class Star
          attr_reader :id, :name, :domain, :content, :spectral_class,
                      :discovered_at, :constellation_ids
          attr_accessor :magnitude

          def initialize(name:, domain:, content:,
                         magnitude: nil, spectral_class: nil)
            validate_domain!(domain)
            assign_core(name, domain, content)
            assign_metadata(magnitude, spectral_class)
          end

          def dim!(rate: Constants::MAGNITUDE_DECAY)
            @magnitude = (@magnitude - rate.abs).clamp(0.0, 1.0).round(10)
            self
          end

          def brighten!(boost: 0.1)
            @magnitude = (@magnitude + boost.abs).clamp(0.0, 1.0).round(10)
            self
          end

          def supergiant?
            @magnitude >= 0.8
          end

          def fading?
            @magnitude < 0.2
          end

          def join_constellation(constellation_id)
            @constellation_ids << constellation_id unless @constellation_ids.include?(constellation_id)
          end

          def magnitude_label
            Constants.label_for(Constants::MAGNITUDE_LABELS, @magnitude)
          end

          def to_h
            {
              id:                @id,
              name:              @name,
              domain:            @domain,
              content:           @content,
              spectral_class:    @spectral_class,
              magnitude:         @magnitude,
              magnitude_label:   magnitude_label,
              discovered_at:     @discovered_at,
              constellation_ids: @constellation_ids,
              supergiant:        supergiant?,
              fading:            fading?
            }
          end

          private

          def assign_core(name, domain, content)
            @id      = SecureRandom.uuid
            @name    = name.to_s
            @domain  = domain.to_sym
            @content = content.to_s
          end

          def assign_metadata(magnitude, spectral_class)
            @magnitude         = (magnitude || 0.5).to_f.clamp(0.0, 1.0).round(10)
            @spectral_class    = (spectral_class || Constants::SPECTRAL_CLASSES.sample).to_sym
            @discovered_at     = Time.now.utc
            @constellation_ids = []
          end

          def validate_domain!(val)
            return if Constants::DOMAINS.include?(val.to_sym)

            raise ArgumentError,
                  "unknown domain: #{val.inspect}; " \
                  "must be one of #{Constants::DOMAINS.inspect}"
          end
        end
      end
    end
  end
end
