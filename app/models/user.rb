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

  def self.authorize!(env)
    user_id = decode_user_id(env)
    if user_id.nil?
      nil
    else
      user = find(user_id).first
      present_user(user, jwt(env))
    end
  end

  def self.decode_user_id(env)
    jwt = jwt(env)
    begin
      JsonWebToken.decode(jwt)[0]['user_id']
    rescue JWT::DecodeError
      nil
    rescue JWT::ExpiredSignature
      nil
    rescue JWT::InvalidIssuerError
      nil
    rescue JWT::InvalidIatError
      nil
    end
  end

  def self.jwt(env)
    env['HTTP_AUTHORIZATION'].split[1]
  end

  def self.present_user(user, jwt)
    Hash[:user, user.values.merge!(token: jwt)]
  end
end
