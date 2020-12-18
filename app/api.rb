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
      desc 'Create a new user.'
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
        token = JsonWebToken.encode(user_id: user.id)
        response.merge!(user.values)
        response[:token] = token
        {'user' => response}
      end

      desc 'Login a user.'
      params do
        requires :user, type: Hash do
          requires :email, type: String
          requires :password, type: String
        end
      end
      post '/login' do
        response = {}
        user = User.where(
          email: params['user']['email'],
          password: params['user']['password']
          ).first
        token = JsonWebToken.encode(user_id: user.id)
        response.merge!(user.values)
        response[:token] = token
        {'user' => response}
      end
    end

    namespace 'user' do
      desc 'Get current user.'
      get do
        response = {}
        token = headers['Authorization'].split[1]
        decoded_token = JsonWebToken.decode(token)
        user = User.find(decoded_token[0]['user_id']).first
        response.merge!(user.values)
        response[:token] = token
        {'user' => response}
      end

      desc 'Update a user.'
      params do
        requires :user, type: Hash do
          optional :email, type: String
          optional :username, type: String
          optional :image, type: String
          optional :bio, type: String
          optional :password, type: String
        end
      end
      put do
        response = {}
        token = headers['Authorization'].split[1]
        decoded_token = JsonWebToken.decode(token)
        user = User.find(decoded_token[0]['user_id']).first
        user.update(params['user'])
        response.merge!(user.values)
        response[:token] = token
        {'user' => response}
      end
    end
  end
end
