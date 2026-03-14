# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveConstellation
      module Helpers
        class SkyEngine
          def initialize
            @stars          = {}
            @constellations = {}
          end

          def discover_star(name:, domain:, content:, magnitude: nil, spectral_class: nil)
            raise ArgumentError, 'sky catalog full' if @stars.size >= Constants::MAX_STARS

            star = Star.new(name: name, domain: domain, content: content,
                            magnitude: magnitude, spectral_class: spectral_class)
            @stars[star.id] = star
            star
          end

          def form_constellation(name:, pattern_type:, star_ids: [])
            raise ArgumentError, 'too many constellations' if @constellations.size >= Constants::MAX_CONSTELLATIONS

            constellation = Constellation.new(name: name, pattern_type: pattern_type)
            @constellations[constellation.id] = constellation

            star_ids.each { |sid| link_star(star_id: sid, constellation_id: constellation.id) }
            constellation
          end

          def link_star(star_id:, constellation_id:)
            star = fetch_star(star_id)
            constellation = fetch_constellation(constellation_id)

            constellation.add_star(star_id)
            star.join_constellation(constellation_id)
          end

          def brighten_star(star_id:, boost: 0.1)
            fetch_star(star_id).brighten!(boost: boost)
          end

          def dim_all!(rate: Constants::MAGNITUDE_DECAY)
            @stars.each_value { |s| s.dim!(rate: rate) }
            pruned = @stars.select { |_, s| s.magnitude < Constants::MIN_MAGNITUDE }.keys
            pruned.each { |id| remove_star(id) }
            { remaining: @stars.size, pruned: pruned.size }
          end

          def navigate(from_star_id:, target_domain:)
            from = fetch_star(from_star_id)
            shared = from.constellation_ids.flat_map do |cid|
              fetch_constellation(cid).star_ids
            end.uniq - [from_star_id]

            shared.filter_map { |sid| @stars[sid] }
                  .select { |s| s.domain == target_domain.to_sym }
                  .sort_by { |s| -s.magnitude }
          end

          def stars_by_domain
            counts = Constants::DOMAINS.to_h { |d| [d, 0] }
            @stars.each_value { |s| counts[s.domain] += 1 }
            counts
          end

          def brightest(limit: 5)
            @stars.values.sort_by { |s| -s.magnitude }.first(limit)
          end

          def faintest(limit: 5)
            @stars.values.sort_by(&:magnitude).first(limit)
          end

          def largest_constellations(limit: 5)
            @constellations.values.sort_by { |c| -c.size }.first(limit)
          end

          def sky_report
            {
              total_stars:          @stars.size,
              total_constellations: @constellations.size,
              by_domain:            stars_by_domain,
              supergiants:          @stars.count { |_, s| s.supergiant? },
              fading:               @stars.count { |_, s| s.fading? },
              avg_magnitude:        avg_magnitude
            }
          end

          def all_stars
            @stars.values
          end

          def all_constellations
            @constellations.values
          end

          private

          def fetch_star(id)
            @stars.fetch(id) { raise ArgumentError, "star not found: #{id}" }
          end

          def fetch_constellation(id)
            @constellations.fetch(id) { raise ArgumentError, "constellation not found: #{id}" }
          end

          def remove_star(id)
            star = @stars.delete(id)
            return unless star

            star.constellation_ids.each do |cid|
              @constellations[cid]&.remove_star(id)
            end
          end

          def avg_magnitude
            return 0.0 if @stars.empty?

            (@stars.values.sum(&:magnitude) / @stars.size).round(10)
          end
        end
      end
    end
  end
end
