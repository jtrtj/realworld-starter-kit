require './db/database'
require_relative 'tag'
require_relative 'tagmapping'

class Article < Sequel::Model(Database.instance.conn)
  plugin :timestamps
  many_to_one :user
  many_to_many :tags, join_table: :tag_mappings

  def self.create_new(params, user)
    article = Article.create(
      params[:article]
      .except(:tagList)
      .merge({ user: user })
    )
    article&.process_tags(params[:article][:tagList])
    article
  end

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

  def process_tags(tags)
    tags.each do |tag_name|
      tag = Tag.find_or_create(name: tag_name)
      TagMapping.find_or_create(tag: tag, article: self) if tag
    end
  end

  private

  def sluggify(title)
    title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end
end
