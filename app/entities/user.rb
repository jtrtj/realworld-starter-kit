require 'grape-entity'

module Conduit
  module Entities
    class User < Grape::Entity
      expose :username
      expose :bio
      expose :image
      expose :following

      private

      def following
        requesting_user = options[:requesting_user]
        if requesting_user
          requesting_user.following?(object)
        else
          false
        end
      end
    end
  end
end
