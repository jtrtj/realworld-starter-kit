require './app/api'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end

  context 'GET /articles/:slug' do
    it 'No authentication required, will return single article' do
      user = User.create(
        email: Faker::Internet.email,
        username: Faker::Internet.username,
        password: Faker::Internet.password
      )
      params = {
        article: {
          title: Faker::Marketing.buzzwords,
          description: Faker::Lorem.sentence,
          body: Faker::Lorem.sentence,
          tagList: Faker::Lorem.words(number: 4)
        }
      }
      article = Article.create_new(params, user)

      expected = {
        'article' => {
          'slug' => article.slug,
          'title' => article.title,
          'description' => article.description,
          'body' => article.body,
          'tagList' => article.tag_list,
          'createdAt' => article.created_at.strftime('%Y-%m-%dT%H:%M:%SZ'),
          'updatedAt' => article.updated_at.strftime('%Y-%m-%dT%H:%M:%SZ'),
          'favorited' => false,
          'favoritesCount' => 0,
          'author' => {
            'username' => user.username,
            'bio' => user.bio,
            'image' => user.image,
            'following' => false
          }
        }
      }
      get "api/articles/#{article.slug}"

      actual = JSON.parse(last_response.body)
      expect(actual).to eq(expected)
    end
  end
end
