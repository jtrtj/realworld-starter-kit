require './db/database'
require_relative 'tag'
require_relative 'tagmapping'
require_relative 'favorite'

class Article < Sequel::Model(Database.instance.conn)
  plugin :timestamps
  many_to_one :user
  many_to_many :tags, join_table: :tag_mappings
  one_to_many :favorites
  one_to_many :comments

  def self.create_new(params, user)
    article = create(
      params[:article]
      .except(:tagList)
      .merge({ user: user })
    )
    article&.process_tags(params[:article][:tagList])
    article.save
  end

  def self.list(params)
    # can't get deault params working with grape
    params[:limit] = 20 if params[:limit].nil?

    limit(params[:limit], params[:offset])
      .order(Sequel.desc(:created_at))
      .all
  end

  def after_save
    self.slug = sluggify(title) + "-#{id}"
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

  def favorites_count
    favorites.count
  end

  def favorited(user)
    Favorite.exists?(article: self, user: user)
  end

  def sluggify(title)
    title
      .downcase
      .strip
      .gsub(' ', '-')
      .gsub(/[^\w-]/, '')
  end
end
