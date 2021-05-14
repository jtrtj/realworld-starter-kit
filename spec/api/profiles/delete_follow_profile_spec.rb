require './app/api/'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end
  context 'DELETE /profiles/:username/follow' do
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
      it 'unfollows the user and returns profile of the unfollowed user' do
        post "api/profiles/#{@user.username}/follow"
        delete "api/profiles/#{@user.username}/follow"

        expected = {
          'profile' =>
            {
              'username' => @user.username,
              'bio' => @user.bio,
              'image' => @user.image,
              'following' => false
            }
        }

        actual = JSON.parse(last_response.body)

        expect(actual).to eq(expected)
      end
    end
  end
end
