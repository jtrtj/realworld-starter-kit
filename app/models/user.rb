require 'jwt'

class User < Sequel::Model
  def after_create
    payload = { data: 'test' }
    token = JWT.encode payload, nil, 'none'
    self.token = token
    super
  end
end
