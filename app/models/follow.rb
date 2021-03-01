require './db/database'

class Follow < Sequel::Model(Database.instance.conn)
  unrestrict_primary_key

  def self.create_new(follower:, user:)
    create(user_id: user.id, follower_id: follower.id)
  end

  def self.exists?(follower:, user:)
    with_pk([user.id, follower.id]) ? true : false
  end
end
