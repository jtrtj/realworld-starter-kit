require './db/database'

class Article < Sequel::Model(Database.instance.conn)
  plugin :timestamps
end
