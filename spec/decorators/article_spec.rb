require './app/models/user'
require './app/services/json_web_token'
require './app/decorators/article'

describe Decorator::Article do
  context 'Instance methods' do
    before do
      @user = User.create(
        email: Faker::Internet.email,
        username: Faker::Internet.username,
        password: Faker::Internet.password
      )
      @requesting_user = User.create(
        email: Faker::Internet.email,
        username: Faker::Internet.username,
        password: Faker::Internet.password
      )
      @article = Article.create(
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.sentence,
        body: Faker::Lorem.sentence,
        user_id: @user.id
      )
    end

    context 'Presents an article ' do
      context '#to_h' do
        it "Includes the author's profile in the author key" do
          expected_author = Decorator::Profile.new(@user, @requesting_user).to_h

          article = Decorator::Article.new(@article, @requesting_user).to_h

          expect(article[:author]).to eq(expected_author)
        end
      end
    end
  end
end
