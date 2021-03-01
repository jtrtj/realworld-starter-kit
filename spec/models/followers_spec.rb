require './app/models/follower'

describe Follower do
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
    context '.new' do
      it 'Creates a follower relationship between two users' do
        described_class.create_new(@following_user, @user)
        follower = described_class.with_pk!([@user.id, @following_user.id])
        expect(follower.user_id).to eq(@user.id)
        expect(follower.follower_id).to eq(@following_user.id)
      end
    end
  end
end
