require 'grape-entity'

module Conduit
  module Entities
    class Profile < Grape::Entity
      expose :profile do |user, options|
        Conduit::Entities::User.represent(user, requesting_user: options[:user])
      end
    end
  end
end
