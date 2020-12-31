require './app/api/'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end
  context 'GET /user' do
    context 'media-type: application/json' do
      before do
        @user = User.create(
          email: 'coolguy@org.gov',
          username: 'Guy',
          password: 'secretss'
        )
        @token = JsonWebToken.encode(user_id: @user.id)

        header 'Content-Type', 'application/json'
        header 'Authorization', "Token #{@token}"
      end

      it 'returns a the current User' do
        get 'api/user'
        expected = {
          'user' =>
            {
              'id' => @user.id,
              'email' => @user.email,
              'username' => @user.username,
              'password' => @user.password,
              'bio' => @user.bio,
              'image' => @user.image,
              'token' => @token
            }
        }
        actual = JSON.parse(last_response.body)
        expect(actual).to eq(expected)
      end
    end
  end
end
