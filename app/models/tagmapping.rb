require './db/database'

class TagMapping < Sequel::Model(Database.instance.conn)
  many_to_one :article
  many_to_one :tag
end
