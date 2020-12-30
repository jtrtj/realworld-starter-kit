require './app/api/'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end
  context 'POST /users' do
    context 'media-type: application/json' do
      it 'returns a the current User' do
        request_body = { 'user':
                   {
                     'email': 'cool@guy.org',
                     'password': 'ssssecret',
                     'username': 'coolDude'
                   } }

        post 'api/users', request_body

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
