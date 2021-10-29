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
    order(Sequel.desc(:created_at))
      .limit(params.fetch(:limit, 20), params.fetch(:offset, 0))
      .all
  end

  def self.filter_by_tag(params)
    tag = Tag.find(name: params[:tag])
    return [] unless tag

    where(tags: tag)
      .limit(params.fetch(:limit, 20), params.fetch(:offset, 0))
      .order(Sequel.desc(:created_at))
      .all
  end

  def self.filter_by_author(params)
    author = User.find(username: params[:author])
    return [] unless author

    where(user: author)
      .limit(params.fetch(:limit, 20), params.fetch(:offset, 0))
      .order(Sequel.desc(:created_at))
      .all
  end

  def self.filter_by_favorited(params)
    user = User.find(username: params[:favorited])
    return [] unless user

    join(Favorite.where(user_id: user.id), article_id: :id)
      .limit(params.fetch(:limit, 20), params.fetch(:offset, 0))
      .order(Sequel.desc(:created_at))
      .all
  end

  def self.feed(params, requesting_user)
    Article.join(:follows, user_id: :user_id)
           .where(follower_id: requesting_user.id)
           .order(Sequel.desc(:created_at))
           .limit(params.fetch(:limit, 20), params.fetch(:offset, 0))
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
