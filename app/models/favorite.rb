require './db/database'

class Favorite < Sequel::Model(Database.instance.conn)
  many_to_one :article

  def self.exists?(article:, user:)
    with_pk([article.id, user.id]) ? true : false
  end
end
