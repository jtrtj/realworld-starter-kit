module Decorator
  class Profile
    def initialize(user, requesting_user)
      @user = user
      @requesting_user = requesting_user
    end

    def to_h
      {
        profile:
        {
          username: user.username,
          bio: user.bio,
          image: user.image,
          following: following?
        }
      }
    end

    private

    attr_reader :user, :requesting_user

    def following?
      requesting_user.nil? ? false : Follow.exists?(follower: requesting_user, user: user)
    end
  end
end
