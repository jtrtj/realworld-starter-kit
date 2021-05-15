module Decorator
  class Article
    def initialize(article, requesting_user)
      @article = article
      @requesting_user = requesting_user
    end

    def to_h
      {
        slug: article.slug,
        title: article.title,
        description: article.description,
        body: article.body,
        tagList: [],
        createdAt: article.created_at,
        updatedAt: article.updated_at,
        favorited: true,
        favoritesCount: 0,
        author: author
      }
    end

    private

    attr_reader :article, :requesting_user

    def author
      Decorator::Profile.new(article.user, requesting_user).to_h
    end
  end
end
