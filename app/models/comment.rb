require './db/database'

class Comment < Sequel::Model(Database.instance.conn)
  plugin :timestamps
  many_to_one :user
  many_to_one :article
end
