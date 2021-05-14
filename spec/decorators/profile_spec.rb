require './app/models/user'
require './app/services/json_web_token'
require './app/decorators/profile'

describe Decorator::Profile do
  context 'Instance methods' do
    before do
      @user = User.create(
        email: 'coolguy@org.gov',
        username: 'Guy',
        password: 'secretss'
      )
      @requesting_user = User.create(
        email: 'pyguy@pipi.xyz',
        username: 'Billie',
        password: 'secretss'
      )
    end

    context "Presents a user's profile" do
      context '#to_h' do
        it 'Returns following: true if the requesting user follows the user' do
          expected = {
            profile:
              {
                username: @user.username,
                bio: @user.bio,
                image: @user.image,
                following: true
              }
          }

          Follow.create_new(follower: @requesting_user, user: @user)

          actual = described_class.new(@user, @requesting_user).to_h

          expect(actual).to eq(expected)
        end

        it "Returns following: false if the requesting user doesn't follow the user" do
          expected = {
            profile:
              {
                username: @user.username,
                bio: @user.bio,
                image: @user.image,
                following: false
              }
          }

          actual = described_class.new(@user, @requesting_user).to_h

          expect(actual).to eq(expected)
        end
        it 'Still works without a requesting user (auth optional)' do
          expected = {
            profile:
              {
                username: @user.username,
                bio: @user.bio,
                image: @user.image,
                following: false
              }
          }

          actual = described_class.new(@user, nil).to_h

          expect(actual).to eq(expected)
        end
      end
    end
  end
end
