require './app/models/user'

describe User do
  context 'Class Methods' do
    before do
      @user = User.create(
        email: 'coolguy@org.gov',
        username: 'Guy',
        password: 'secretss'
      )
      @token = JsonWebToken.encode(user_id: @user.id)
    end
    context '.authorize!' do
      it 'Checks if token is valid and returns the User if valid' do
        current_user = described_class.authorize!(@token)
        expect(current_user.id).to eq(@user.id)
      end
    end
    context '.create_new' do
      it 'Creates a new user and returns its attributes with a new jwt' do
        initial_user_count = User.count
        params = { user:
                   {
                     email: 'cool@guy.org',
                     password: 'ssssecret',
                     username: 'coolDude'
                   } }
        new_user = User.create_new(params)

        expect(new_user[:user][:email]).to eq(params[:user][:email])
        expect(new_user[:user][:username]).to eq(params[:user][:username])
        expect(new_user[:user][:token]).to_not be_nil
        expect(User.count).to eq(initial_user_count + 1)
      end
    end
    context '.login' do
      it 'Logs in a user and returns its attributes with a new jwt' do
        params = { user:
                   {
                     email: @user.email,
                     password: @user.password
                   } }
        logged_in_user = User.login(params)
        expect(logged_in_user[:user][:email]).to eq(@user.email)
        expect(logged_in_user[:user][:username]).to eq(@user.username)
        expect(logged_in_user[:user][:token]).to_not be_nil
        expect(logged_in_user[:user][:id]).to eq(@user.id)
      end
    end

    context '.update' do
      it "updates a user's attribute(s) and returns them with request's jwt" do
        params = {
          user:
           {
             email: 'new@email.address'
           }
        }

        User.update(@user, params)
        updated_user = User.find(@user.id).first
        expect(updated_user.email).to eq(params[:user][:email])
      end
    end
  end
end
