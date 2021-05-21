require './app/api'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end

  context 'POST /articles/:slug/favorite' do
    it 'Authentication required, returns the Article' do
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

      expect(article.favorites.count).to eq(0)

      token = JsonWebToken.encode(user_id: user.id)
      header 'Content-Type', 'application/json'
      header 'Authorization', "Token #{token}"

      post "api/articles/#{article.slug}/favorite"

      actual = JSON.parse(last_response.body)
      article.refresh
      expect(article.favorites.count).to eq(1)
      expect(article.favorites.first.user).to eq(user)
      expect(actual['article']['slug']).to eq(article.slug)
    end
  end
end
