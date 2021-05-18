require './app/api'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end

  context 'POST /articles' do
    it 'Authentication required, will return an Article' do
      user = User.create(
        email: Faker::Internet.email,
        username: Faker::Internet.username,
        password: Faker::Internet.password
      )

      request_body = {
        article: {
          title: 'How to train your dragon',
          description: 'Ever wonder how?',
          body: 'You have to believe',
          tagList: %w[reactjs angularjs dragons]
        }
      }

      token = JsonWebToken.encode(user_id: user.id)
      header 'Content-Type', 'application/json'
      header 'Authorization', "Token #{token}"

      post 'api/articles', JSON.generate(request_body)

      actual = JSON.parse(last_response.body)
      new_article = actual['article']

      expect(new_article['title']).to eq(request_body[:article][:title])
      expect(new_article['description']).to eq(request_body[:article][:description])
      expect(new_article['body']).to eq(request_body[:article][:body])
      expect(new_article['tagList']).to eq(request_body[:article][:tagList])
    end
  end
end
