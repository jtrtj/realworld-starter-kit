require './app/models/article'

describe Article do
  context 'Class Methods' do
    context '.process_tags' do
      it 'Given a tagList, creates tags and article_tags if they do not all ready exist' do
      end
    end
  end
  context 'Instance Methods' do
    context '#before_save' do
      it 'Creates slug from title when creating and updating' do
        article = Article.create(title: 'This is cool!')

        expect(article.slug).to eq('this-is-cool')

        article.update(title: 'This was cool?')

        expect(article.slug).to eq('this-was-cool')
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
