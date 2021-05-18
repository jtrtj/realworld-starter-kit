require './app/api'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end

  context 'PUT /articles/:slug' do
    it 'Authentication required, returns the updated Article' do
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
      token = JsonWebToken.encode(user_id: user.id)

      header 'Content-Type', 'application/json'
      header 'Authorization', "Token #{token}"

      request_body = {
        article: {
          title: 'Did you train your dragon?'
        }
      }
      new_slug = article.sluggify(request_body[:article][:title]) + "-#{article.id}"

      put "api/articles/#{article.slug}", JSON.generate(request_body)

      actual = JSON.parse(last_response.body)
      new_article = actual['article']

      expect(new_article['title']).to eq(request_body[:article][:title])
      expect(new_article['slug']).to eq(new_slug)
    end
  end
end
