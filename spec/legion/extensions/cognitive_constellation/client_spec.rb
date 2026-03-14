# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveConstellation::Client do
  subject(:client) { described_class.new }

  it 'includes the runner module' do
    expect(client).to respond_to(:discover_star)
  end

  it 'includes all runner methods' do
    %i[discover_star form_constellation navigate
       list_stars list_constellations sky_status].each do |m|
      expect(client).to respond_to(m)
    end
  end
end
