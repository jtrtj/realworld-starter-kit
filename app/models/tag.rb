require './db/database'

class Tag < Sequel::Model(Database.instance.conn)
  many_to_many :articles, join_table: :tag_mappings
end
