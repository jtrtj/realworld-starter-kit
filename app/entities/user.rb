require 'grape-entity'

module Conduit
  module Entities
    class User < Grape::Entity
      expose :username
      expose :bio
      expose :image
      expose :following, if: ->(_user, options) { options[:type] == :author }

      private

      def following
        requesting_user = options[:requesting_user]
        if requesting_user
          requesting_user.following?(user: object)
        else
          false
        end
      end
    end
  end
end
