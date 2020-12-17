require 'jwt'
SECRET_KEY = "secret"

class JsonWebToken
  def self.encode(payload, exp = (Time.now + (24 * 60 * 60)))
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY)
  end
end
