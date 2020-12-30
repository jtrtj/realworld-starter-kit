require './app/api/'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end
  context 'POST /users/login' do
    context 'media-type: application/json' do
      it 'logs in a User and returns it' do
        user = User.create(
          email: 'coolguy@org.gov',
          username: 'Guy',
          password: 'secretss'
        )

        request_body =  { 'user':
                                 {
                                   'email': user.email,
                                   'password': user.password,
                                 }
                         }

        post 'api/users/login', request_body

        response_body = JSON.parse(last_response.body)
        new_user = User.find(response_body['user']['id']).first

        expect(last_response.status).to eq(201)
        expect(new_user.email).to eq(response_body['user']['email'])
        expect(new_user.username).to eq(response_body['user']['username'])
        expect(response_body['user']['token']).to_not be_nil
      end
    end
  end
end
