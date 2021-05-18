require './app/api'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end

  context 'DELET /articles/:slug' do
    it 'Authentication required' do
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

      delete "api/articles/#{article.slug}"

      expect(Article[article.id]).to be(nil)
    end
  end
end
