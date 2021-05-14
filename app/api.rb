require 'grape'
require_relative 'models/user'
require_relative 'decorators/user'

module Conduit
  class API < Grape::API
    prefix :api
    format :json

    helpers do
      def current_user
        @current_user ||= User.authorize!(token)
      end

      def authenticate!
        error!('401 Unauthorized', 402) unless current_user
      end

      def optional_auth
        token ? authenticate! : @current_user = nil
      end

      def token
        token = env['HTTP_AUTHORIZATION']
        token.nil? ? token : token.split[1]
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
        Decorator::User.new(@current_user, token).to_h
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
        user = User.update(@current_user, params)
        Decorator::User.new(user, token).to_h
      end
    end

    namespace 'profiles' do
      desc "Get a user's profile."
      get ':username' do
        optional_auth
        user = User[username: params[:username]]
        if user
          Decorator::Profile.new(user, @current_user).to_h
        else
          status 404
        end
      end
      desc 'Follow a user.'
      post ':username/follow' do
        authenticate!
        user = User[username: params[:username]]
        if user
          follow = @current_user.follow(user)
        else
          status 404
        end
        if follow
          Decorator::Profile.new(user, @current_user).to_h
        else
          status 404
        end
      end
      desc 'Unfollow a user.'
      delete ':username/follow' do
        authenticate!
        user = User[username: params[:username]]
        if user
          follow = @current_user.unfollow(user)
        else
          status 404
        end
        if follow
          Decorator::Profile.new(user, @current_user).to_h
        else
          status 404
        end
      end
    end
  end
end
