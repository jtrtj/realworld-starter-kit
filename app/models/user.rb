require './db/database'
require './app/services/json_web_token'

class User < Sequel::Model(Database.instance.conn)
  def self.create_new(params)
    user = create(params[:user])
    token = JsonWebToken.encode(user_id: user.id)
    present_user(user, token)
  end

  def self.login(params)
    user = User.where(
      email: params[:user][:email],
      password: params[:user][:password]
    ).first
    token = JsonWebToken.encode(user_id: user.id)
    present_user(user, token)
  end

  def self.update(user, params)
    found_user = User.find(user[:user][:id]).first
    found_user.update(params[:user])
    present_user(found_user, user[:user][:token])
  end

  def self.authorize!(env)
    token = env['HTTP_AUTHORIZATION'].split[1]
    decoded_token = JsonWebToken.decode(token)
    if decoded_token.nil?
      nil
    else
      user = find(decoded_token.user_id).first
      present_user(user, token)
    end
  end

  def self.present_user(user, jwt)
    Hash[:user, user.values.merge!(token: jwt)]
  end
end
