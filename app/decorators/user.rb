module Decorator
  class User
    def initialize(user, token = nil)
      @values = user.values
      @token = token
    end

    def to_h
      Hash[:user, @values.merge!(token: @token)]
    end
  end
end
