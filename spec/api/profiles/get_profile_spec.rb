require './app/api/'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end
  context 'GET /profiles/:username' do
    context 'media-type: application/json' do
      before do
        @requesting_user = User.create(
          email: 'coolguy@org.gov',
          username: 'Guy',
          password: 'secretss'
        )
        @token = JsonWebToken.encode(user_id: @requesting_user.id)
        @user = User.create(
          email: 'season@11.biz',
          username: 'Aquaria',
          password: 'secretss',
          bio: 'Season 11 winner',
          image: '123.some-bucket.com/image.jpg'
        )
        Follow.create_new(follower: @requesting_user, user: @user)

        header 'Content-Type', 'application/json'
        header 'Authorization', "Token #{@token}"
      end

      it 'returns the requested profile' do
        get "api/profiles/#{@user.username}"

        expected = {
          'profile' =>
            {
              'username' => @user.username,
              'bio' => @user.bio,
              'image' => @user.image,
              'following' => true
            }
        }
        actual = JSON.parse(last_response.body)

        expect(actual).to eq(expected)
      end

      it 'returns 404 if user does not exist' do
        get 'api/profiles/does_not_exist'

        expect(last_response.status).to eq(404)
      end
    end
  end
end
