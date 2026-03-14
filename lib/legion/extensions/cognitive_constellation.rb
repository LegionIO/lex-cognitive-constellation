# frozen_string_literal: true

require 'securerandom'

require_relative 'cognitive_constellation/version'
require_relative 'cognitive_constellation/helpers/constants'
require_relative 'cognitive_constellation/helpers/star'
require_relative 'cognitive_constellation/helpers/constellation'
require_relative 'cognitive_constellation/helpers/sky_engine'
require_relative 'cognitive_constellation/runners/cognitive_constellation'
require_relative 'cognitive_constellation/client'

module Legion
  module Extensions
    module CognitiveConstellation
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
