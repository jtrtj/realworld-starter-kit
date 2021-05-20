require 'grape-entity'
require_relative 'user'

module Conduit
  module Entities
    class Comment < Grape::Entity
      root 'comments', 'comment'
      expose :id
      expose :created_at, as: :createdAt
      expose :updated_at, as: :updatedAt
      expose :body
      expose :author do |article, options|
        Conduit::Entities::User.represent(article.user, requesting_user: options[:user])
      end
    end
  end
end
