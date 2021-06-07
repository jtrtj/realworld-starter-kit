require 'grape-entity'
require_relative 'user'

module Conduit
  module Entities
    class Article < Grape::Entity
      root 'articles', 'article'
      expose :slug, :title, :description, :body
      expose :tag_list, as: :tagList
      expose :created_at, as: :createdAt
      expose :updated_at, as: :updatedAt
      expose :favorites_count, as: :favoritesCount
      expose :favorited
      expose :user, as: :author do |article, options|
        Conduit::Entities::User.represent(article.user, requesting_user: options[:user])
      end

      private

      def favorited
        requesting_user = options[:requesting_user]
        if requesting_user
          object.favorited(requesting_user)
        else
          false
        end
      end
    end
  end
end
