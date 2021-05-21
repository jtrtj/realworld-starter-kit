require './app/api'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end

  context 'GET /tags' do
    it 'No authentication required, returns a List of Tags' do
      tags = %w[2021 incredible wow iLoVeIt]
      tags.each do |tag|
        Tag.create(name: tag)
      end

      expected = {
        'tags' => tags
      }

      get 'api/tags'

      actual = JSON.parse(last_response.body)

      expect(actual).to eq(expected)
    end
  end
end
