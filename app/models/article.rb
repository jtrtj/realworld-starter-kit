require './db/database'
require_relative 'tag'
require_relative 'tagmapping'

class Article < Sequel::Model(Database.instance.conn)
  plugin :timestamps
  many_to_one :user
  many_to_many :tags, join_table: :tag_mappings

  def before_save
    self.slug = sluggify(title)
    super
  end

  def tag_list
    tags.map(&:name)
  end

  def tag(tags)
    tags.each do |tag|
      TagMapping.create(article: self, tag: tag)
    end
  end

  private

  def sluggify(title)
    title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end
end
