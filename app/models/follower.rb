require './db/database'
require './app/models/user'

class Follower < Sequel::Model(Database.instance.conn)
  unrestrict_primary_key

  def self.create_new(following_user, user)
    create(user_id: user.id, follower_id: following_user.id)
  end

  def self.following?(following_user, user)
    with_pk([user.id, following_user.id]) ? true : false
  end
end
