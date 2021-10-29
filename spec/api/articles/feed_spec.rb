require './app/api'

describe Conduit::API do
  include Rack::Test::Methods
  def app
    OUTER_APP
  end

  context 'GET /articles/feed' do
    before(:each) do
      @user = User.create(
        email: Faker::Internet.email,
        username: Faker::Internet.username,
        password: Faker::Internet.password
      )

      followed_users = (1..10).map do
        User.create(
          email: Faker::Internet.email,
          username: Faker::Internet.username,
          password: Faker::Internet.password
        )
      end
      followed_users.each do |user|
        @user.follow(user)
      end

      unfollowed_users = (1..10).map do
        User.create(
          email: Faker::Internet.email,
          username: Faker::Internet.username,
          password: Faker::Internet.password
        )
      end

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

      @articles_from_followed = params[0..((params.count / 2) - 1)].map do |article_params|
        user = followed_users[rand(0..(followed_users.count - 1))]
        # overrite created_at so that there is some variety
        article_params[:article][:created_at] = Time.now + rand(0..1000)
        Article.create_new(article_params, user)
      end

      articles_from_unfollowed = params[((params.count / 2))..(params.count - 1)].map do |article_params|
        user = unfollowed_users[rand(0..(followed_users.count - 1))]
        # overrite created_at so that there is some variety
        article_params[:article][:created_at] = Time.now + rand(0..1000)
        Article.create_new(article_params, user)
      end

      @token = JsonWebToken.encode(user_id: @user.id)
      header 'Content-Type', 'application/json'
      header 'Authorization', "Token #{@token}"
    end

    it 'Returns most recent articles written by followed users' do
      get 'api/articles/feed'

      actual = JSON.parse(last_response.body)

      expect(actual['articles'].count).to eq(@articles_from_followed.count)
      expect(actual['articlesCount']).to eq(22)
      expect(actual['articles'][0]['createdAt']).to be > actual['articles'][6]['createdAt']
    end

    it 'Returns most recent articles written by followed users with limit and offset' do
      limit = 10
      get "api/articles/feed?limit=#{limit}&offset=0"

      actual = JSON.parse(last_response.body)

      expect(actual['articles'].count).to eq(limit)
      expect(actual['articlesCount']).to eq(22)
      expect(actual['articles'][0]['createdAt']).to be > actual['articles'][6]['createdAt']
    end
  end
end
