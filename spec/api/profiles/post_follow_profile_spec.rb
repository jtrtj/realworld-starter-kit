require './app/api/'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end
  context 'POST /profiles/:username/follow' do
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
        header 'Content-Type', 'application/json'
        header 'Authorization', "Token #{@token}"
      end

      it 'follows the user and returns profile of the followed user' do
        post "api/profiles/#{@user.username}/follow"

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
        delete 'api/profiles/does_not_exist/follow'

        expect(last_response.status).to eq(404)
      end
    end
  end
end
