require './app/api'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end

  context 'POST /articles/:slug/comments' do
    it 'Authentication required, returns the created Comment' do
      user = User.create(
        email: Faker::Internet.email,
        username: Faker::Internet.username,
        password: Faker::Internet.password
      )

      params = {
        article: {
          title: 'How to train your dragon',
          description: 'Ever wonder how?',
          body: 'You have to believe',
          tagList: %w[reactjs angularjs dragons]
        }
      }

      article = Article.create_new(params, user)

      request_body = {
        comment: {
          body: 'His name was my name too.'
        }
      }

      token = JsonWebToken.encode(user_id: user.id)
      header 'Content-Type', 'application/json'
      header 'Authorization', "Token #{token}"

      post "api/articles/#{article.slug}/comments", JSON.generate(request_body)

      actual = JSON.parse(last_response.body)
      new_comment = actual['comment']

      expect(new_comment['body']).to eq(request_body[:comment][:body])
    end
  end
end
