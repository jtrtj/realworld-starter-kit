require 'grape'
require 'sequel'
require 'pg'

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
    format :json

    namespace 'users' do
      desc 'Create new user.'
      params do
        requires :username, type: String
        requires :email, type: String
        requires :password, type: String
      end
      post do
        user = User.create(params)
        user.values
      end
    end
  end
end
