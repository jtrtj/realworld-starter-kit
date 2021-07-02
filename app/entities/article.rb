require 'grape-entity'
require_relative 'user'
require_relative 'helpers'

module Conduit
  module Entities
    class Article < Grape::Entity
      root 'articles', 'article'
      expose :slug, :title, :description, :body
      expose :tag_list, as: :tagList
      expose :favorites_count, as: :favoritesCount
      expose :favorited
      expose :user, as: :author do |article, options|
        Conduit::Entities::User.represent(article.user, requesting_user: options[:user])
      end
      expose :created_at, format_with: :iso_timestamp, as: :createdAt
      expose :updated_at, format_with: :iso_timestamp, as: :updatedAt

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
