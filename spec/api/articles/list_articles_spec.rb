require './app/api'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end

  context 'GET /articles' do
    before(:each) do
      @user = User.create(
        email: Faker::Internet.email,
        username: Faker::Internet.username,
        password: Faker::Internet.password
      )
      params = (1..22).map do |_article_count|
        {
          article: {
            title: Faker::Marketing.buzzwords,
            description: Faker::Lorem.sentence,
            body: Faker::Lorem.sentence,
            tagList: []
          }
        }
      end

      articles = params.map do |article_params|
        # overrite created_at so that there is some variety
        article_params[:article][:created_at] = Time.now + rand(0..1000)
        Article.create_new(article_params, @user)
      end
    end
    it 'Returns most recent articles globally by default, provide tag, author or favorited query parameter to filter results' do
      get 'api/articles'

      actual = JSON.parse(last_response.body)

      expect(actual['articles'].count).to eq(20)
      expect(actual['articlesCount']).to eq(22)
      expect(actual['articles'][0]['createdAt']).to be > actual['articles'][6]['createdAt']
    end

    it 'Articles can be filtered by tag' do
      article_params = {
        article: {
          title: Faker::Marketing.buzzwords,
          description: Faker::Lorem.sentence,
          body: Faker::Lorem.sentence,
          tagList: %w[AngularJS typescript]
        }
      }
      article_with_tag = Article.create_new(article_params, @user)

      get 'api/articles?tag=AngularJS'

      actual = JSON.parse(last_response.body)

      expect(actual['articles'].count).to eq(1)
      expect(actual['articles'][0]['slug']).to eq(article_with_tag.slug)
    end

    it 'Articles can be filtered by author' do
      different_user = User.create(
        email: Faker::Internet.email,
        username: Faker::Internet.username,
        password: Faker::Internet.password
      )

      users_articles_count = 5

      users_articles_count.times do
        article_params = {
          article: {
            title: Faker::Marketing.buzzwords,
            description: Faker::Lorem.sentence,
            body: Faker::Lorem.sentence,
            tagList: %w[AngularJS typescript]
          }
        }
        Article.create_new(article_params, different_user)
      end

      get "api/articles?author=#{different_user.username}"

      actual = JSON.parse(last_response.body)

      expect(actual['articles'].count).to eq(users_articles_count)
      actual['articles'].each do |article|
        expect(article['author']['username']).to eq(different_user.username)
      end
    end
  end
end
