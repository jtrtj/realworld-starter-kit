require './app/models/article'

describe Article do
  context 'Class Methods' do
    context '.create_new' do
      it 'Creates a new article and processes its tags' do
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
        existing_tag = Tag.create(name: 'reactjs')
        expect(Tag.count).to eq(1)

        article = Article.create_new(params, user)

        expect(article.title).to eq(params[:article][:title])
        expect(article.description).to eq(params[:article][:description])
        expect(article.body).to eq(params[:article][:body])
        expect(article.tag_list).to eq(params[:article][:tagList])
        expect(article.user).to eq(user)
        # Tags should not be duplicated
        expect(Tag.count).to eq(3)
      end
    end
  end
  context 'Instance Methods' do
    context '#after_save' do
      it 'Creates slug from title and id when creating and updating' do
        article = Article.create(title: 'This is cool!')

        expect(article.slug).to eq("this-is-cool-#{article.id}")

        article.update(title: 'This was cool?')

        expect(article.slug).to eq("this-was-cool-#{article.id}")
      end
    end

    context '#tag_list' do
      it "Returns an array of the article's tags' names" do
        article = Article.create(title: 'This is cool!')
        tag_names = %w[cool awesome sugoi]
        tags = tag_names.map do |name|
          Tag.create(name: name)
        end
        article.tag(tags)

        expect(article.tag_list).to eq(tag_names)
      end
    end
  end
end
