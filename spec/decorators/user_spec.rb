require './app/models/user'
require './app/services/json_web_token'
require './app/decorators/user'

describe Decorator::User do
  context 'Instance methods' do
    before do
      @user = User.create(
        email: 'coolguy@org.gov',
        username: 'Guy',
        password: 'secretss'
      )
      @token = JsonWebToken.encode(user_id: @user.id)
    end
    it '#to_h' do
      expected = {
        user:
          {
            id: @user.id,
            email: @user.email,
            username: @user.username,
            password: @user.password,
            bio: @user.bio,
            image: @user.image,
            token: @token
          }
      }
      actual = described_class.new(@user, @token).to_h
      expect(actual).to eq(expected)
    end
  end
end
