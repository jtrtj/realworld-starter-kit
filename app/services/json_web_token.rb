require 'jwt'
SECRET_KEY = ENV.fetch('SECRET_KEY')

class JsonWebToken
  def self.encode(payload, exp = (Time.now + (24 * 60 * 60)))
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    token = JWT.decode(token, SECRET_KEY)
    Decoded.new(token)
  rescue JWT::DecodeError
    nil
  rescue JWT::ExpiredSignature
    nil
  end
  
  class Decoded
    attr_reader :user_id, :exp

    def initialize(decoded_token)
      @user_id = decoded_token[0]['user_id']
      @exp = decoded_token[0]['exp']
    end
  end
end
