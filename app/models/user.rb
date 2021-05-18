require './db/database'
require './app/services/json_web_token'
require './app/models/follow'

class User < Sequel::Model(Database.instance.conn)
  one_to_many :article

  def self.create_new(params)
    user = create(params[:user])
    token = JsonWebToken.encode(user_id: user.id)
    Decorator::User.new(user, token).to_h
  end

  def self.login(params)
    user = User.where(
      email: params[:user][:email],
      password: params[:user][:password]
    ).first
    token = JsonWebToken.encode(user_id: user.id)
    Decorator::User.new(user, token).to_h
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

  def follow(user)
    Follow.create_new(follower: self, user: user)
  end

  def unfollow(user)
    Follow.with_pk([user.id, id]).delete
  end

  def following?(user)
    Follow.exists?(follower: self, user: user)
  end
end
