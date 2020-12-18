require './app/api/'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end
  context 'GET /user' do
    context 'media-type: application/json' do
      before do
        user = User.create(
          email: 'coolguy@org.gov',
          username: 'Guy',
          password: 'secretss'
        )
        token = JsonWebToken.encode(user_id: user.id)

        header 'Content-Type', 'application/json'
        header 'Authorization', "Token #{token}"
      end

      it 'returns a the current User' do
        get 'api/user'
      end
    end
  end
end
