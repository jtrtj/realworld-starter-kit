require './app/api'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end

  context 'GET /articles/:slug/comments' do
    it 'Authentication optional, returns multiple comments' do
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

      comments = %w[hey hi hello].map do |comment_body|
        user.comment(article, { body: comment_body })
      end

      get "api/articles/#{article.slug}/comments"

      actual = JSON.parse(last_response.body)

      expect(actual['comments'].count).to eq(3)
    end
  end
end
