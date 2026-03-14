# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveConstellation
      module Runners
        module CognitiveConstellation
          extend self

          def discover_star(name:, domain:, content:,
                            magnitude: nil, spectral_class: nil, engine: nil, **)
            eng  = resolve_engine(engine)
            star = eng.discover_star(name: name, domain: domain, content: content,
                                     magnitude: magnitude, spectral_class: spectral_class)
            { success: true, star: star.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def form_constellation(name:, pattern_type:, star_ids: [], engine: nil, **)
            eng = resolve_engine(engine)
            con = eng.form_constellation(name: name, pattern_type: pattern_type,
                                         star_ids: star_ids)
            { success: true, constellation: con.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def navigate(from_star_id:, target_domain:, engine: nil, **)
            eng     = resolve_engine(engine)
            results = eng.navigate(from_star_id: from_star_id,
                                   target_domain: target_domain)
            { success: true, stars: results.map(&:to_h), count: results.size }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def list_stars(engine: nil, domain: nil, **)
            eng     = resolve_engine(engine)
            results = eng.all_stars
            results = results.select { |s| s.domain == domain.to_sym } if domain
            { success: true, stars: results.map(&:to_h), count: results.size }
          end

          def list_constellations(engine: nil, **)
            eng = resolve_engine(engine)
            { success: true,
              constellations: eng.all_constellations.map(&:to_h),
              count: eng.all_constellations.size }
          end

          def sky_status(engine: nil, **)
            eng = resolve_engine(engine)
            { success: true, report: eng.sky_report }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          private

          def resolve_engine(engine)
            engine || default_engine
          end

          def default_engine
            @default_engine ||= Helpers::SkyEngine.new
          end
        end
      end
    end
  end
end
