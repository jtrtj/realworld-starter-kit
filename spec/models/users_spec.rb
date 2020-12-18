require './app/models/user'

describe User do
  context '.authorize!' do
    before do
      @user = User.create(
        email: 'coolguy@org.gov',
        username: 'Guy',
        password: 'secretss'
      )
      @token = JsonWebToken.encode(user_id: @user.id)
    end

    it 'Checks if token is valid and returns the User if valid' do
      incoming_env = {
        'HTTP_AUTHORIZATION' => "Token #{@token}"
      }

      current_user = described_class.authorize!(incoming_env)
      expect(current_user['user'][:id]).to eq(@user.id)
    end
  end
end
