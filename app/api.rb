require 'grape'
require 'sequel'
require 'pg'
require_relative 'services/json_web_token'

DB = Sequel.connect(
  adapter: 'postgres',
  host: 'db',
  database: 'conduit',
  user: 'postgres',
  password: 'abc'
)

require_relative 'models/user'

module Conduit
  class API < Grape::API
    prefix :api
    format :json

    namespace 'users' do
      desc 'Create new user.'
      params do
        requires :user, type: Hash do
          requires :username, type: String
          requires :email, type: String
          requires :password, type: String
        end
      end

      post do
        response = {}
        user = User.create(params["user"])
        token = JsonWebToken.encode(user: user.username)
        response.merge!(user.values)
        response[:token] = token
        response
      end
    end
  end
end
