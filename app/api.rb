require 'grape'
require_relative 'models/user'
require_relative 'models/article'
require_relative 'entities/article'
require_relative 'decorators/user'
require_relative 'entities/profile'
require_relative 'entities/comment'

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
      post do
        params do
          requires :user, type: Hash do
            requires :username, type: String
            requires :email, type: String
            requires :password, type: String
          end
        end
        User.create_new(params)
      end

      desc 'Login a user.'
      post '/login' do
        params do
          requires :user, type: Hash do
            requires :email, type: String
            requires :password, type: String
          end
        end
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
      put do
        authenticate!

        params do
          requires :user, type: Hash do
            optional :email, type: String
            optional :username, type: String
            optional :image, type: String
            optional :bio, type: String
            optional :password, type: String
          end
        end

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
          present user, with: Entities::Profile, user: @current_user
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
          status 200
          present user, with: Entities::Profile, user: @current_user
        else
          status 404
        end
      end
      desc 'Unfollow a user.'
      delete ':username/follow' do
        authenticate!
        user = User[username: params[:username]]
        if user
          @current_user.unfollow(user)
          present user, with: Entities::Profile, user: @current_user
        else
          status 404
        end
      end
    end

    namespace 'articles' do
      desc 'List articles'
      get do
        optional_auth

        params do
          optional :limit, type: Integer
          optional :offset, type: Integer
          optional :tag, type: String
          optional :author, type: String
          optional :favorited, type: String
          exactly_one_of :tag, :author, :favorited
        end

        list = case params
               when ->(params) { params.key?(:tag) }
                 Article.filter_by_tag(params)
               when ->(params) { params.key?(:author) }
                 Article.filter_by_author(params)
               when ->(params) { params.key?(:favorited) }
                 Article.filter_by_favorited(params)
               else
                 Article.list(params)
               end

        response = Entities::Article.represent(list, user: @current_user)
        response.merge!(articlesCount: Article.count)
      end

      desc 'Get a single article.'
      get ':slug' do
        optional_auth
        article = Article[slug: params[:slug]]
        if article
          present article, with: Entities::Article, user: @current_user
        else
          status 404
        end
      end
      desc 'Create a new article.'
      post do
        authenticate!
        params do
          requires :article, type: Hash do
            requires :title, type: String
            requires :description, type: String
            requires :body, type: String
            optional :tagList, type: Array
          end
        end
        article = Article.create_new(params, @current_user)
        if article
          present article, with: Entities::Article, user: @current_user
        else
          status 400
        end
      end
      desc 'Update an article.'
      put ':slug' do
        authenticate!
        params do
          requires :article, type: Hash do
            optional :title, type: String
            optional :description, type: String
            optional :body, type: String
          end
        end
        article = Article[slug: params[:slug]]
        if article && article.user == @current_user
          article.update(params[:article])
          present article, with: Entities::Article, user: @current_user
        else
          status 404
        end
      end
      desc 'Delete an article.'
      delete ':slug' do
        authenticate!
        article = Article[slug: params[:slug]]
        if article && article.user == @current_user
          article.delete
        else
          status 404
        end
      end
      desc 'Post a comment on an article.'
      post ':slug/comments' do
        authenticate!

        article = Article[slug: params[:slug]]
        if article
          comment = @current_user.comment(article, params[:comment])
          present comment, with: Entities::Comment, user: @current_user
        else
          status 404
        end
      end
      desc "Get an article's comments."
      get ':slug/comments' do
        optional_auth

        article = Article[slug: params[:slug]]
        if article
          present article.comments, with: Entities::Comment, user: @current_user
        else
          status 404
        end
      end
      desc "Delete an article's comment."
      delete ':slug/comments/:id' do
        authenticate!

        comment = Comment[params[:id]]
        if comment && comment.user == @current_user
          comment.delete
        else
          status 404
        end
      end
      desc 'Favorite an article.'
      post ':slug/favorite' do
        authenticate!

        article = Article[slug: params[:slug]]
        if article
          @current_user.favorite(article)
          present article, with: Entities::Article, user: @current_user
        else
          status 404
        end
      end
      desc 'Unfavorite an article.'
      delete ':slug/favorite' do
        authenticate!

        article = Article[slug: params[:slug]]
        favorite = Favorite[user: @current_user, article: article]
        if favorite
          favorite.delete
          present article, with: Entities::Article, user: @current_user
        else
          status 404
        end
      end
    end

    namespace 'tags' do
      desc 'Get all tags'
      get '/' do
        { tags: Tag.all.map(&:name) }
      end
    end
  end
end
