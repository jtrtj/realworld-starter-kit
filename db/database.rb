require 'sequel'
require 'pg'
require 'singleton'

class Database
  include Singleton
  def conn
    @conn ||= Sequel.connect(
      adapter: 'postgres',
      host: ENV.fetch('DB_HOST'),
      database: ENV.fetch('DB_NAME'),
      user: ENV.fetch('DB_USER'),
      password: ENV.fetch('DB_PASSWORD')
    )
  end
end
