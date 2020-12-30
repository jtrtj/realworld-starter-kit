require 'grape'
require_relative 'models/user'

module Conduit
  class API < Grape::API
    prefix :api
    format :json

    helpers do
      def current_user
        @current_user ||= User.authorize!(env)
      end

      def authenticate!
        error!('401 Unauthorized', 402) unless current_user
      end
    end

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
        User.create_new(params)
      end

      desc 'Login a user.'
      params do
        requires :user, type: Hash do
          requires :email, type: String
          requires :password, type: String
        end
      end
      post '/login' do
        User.login(params)
      end
    end

    namespace 'user' do
      desc 'Get current user.'
      get do
        authenticate!
        @current_user
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
        authenticate!
        User.update(@current_user, params)
      end
    end
  end
end
