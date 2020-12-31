require './db/database'
require './app/services/json_web_token'

class User < Sequel::Model(Database.instance.conn)
  def self.create_new(params)
    user = create(params[:user])
    token = JsonWebToken.encode(user_id: user.id)
    User::Decorator.new(user, token).to_h
  end

  def self.login(params)
    user = User.where(
      email: params[:user][:email],
      password: params[:user][:password]
    ).first
    token = JsonWebToken.encode(user_id: user.id)
    User::Decorator.new(user, token).to_h
  end

  def self.update(user, params)
    found_user = User.find(user.id).first
    found_user.update(params[:user])
  end

  def self.authorize!(token)
    decoded_token = JsonWebToken.decode(token)
    if decoded_token.nil?
      nil
    else
      find(decoded_token.user_id).first
    end
  end

  class Decorator
    def initialize(user, token = nil)
      @values = user.values
      @token = token
    end

    def to_h
      Hash[:user, @values.merge!(token: @token)]
    end
  end
end
