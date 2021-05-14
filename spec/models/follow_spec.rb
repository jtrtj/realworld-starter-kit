require './app/models/follow'

describe Follow do
  context 'Class Methods' do
    before do
      @user = User.create(
        email: 'coolguy@org.gov',
        username: 'Guy',
        password: 'secretss'
      )
      @following_user = User.create(
        email: 'vlogger@world.com',
        username: 'Becca',
        password: 'secretss'
      )
    end

    context '.create_new' do
      it 'Creates a follower relationship between two users' do
        described_class.create_new(follower: @following_user, user: @user)
        follower = described_class.with_pk!([@user.id, @following_user.id])
        expect(follower.user_id).to eq(@user.id)
        expect(follower.follower_id).to eq(@following_user.id)
      end
    end

    context '.exists?' do
      it 'Checks whether or not a user is following another user' do
        described_class.create_new(follower: @following_user, user: @user)
        following = described_class.exists?(follower: @following_user, user: @user)
        not_following = described_class.exists?(follower: @user, user: @following_user)
        expect(following).to be true
        expect(not_following).to be false
      end
    end
  end
end
