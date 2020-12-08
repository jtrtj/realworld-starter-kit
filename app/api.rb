require 'grape'
require 'sequel'
require 'pg'

DB = Sequel.connect(
  adapter: "postgres",
  host: "db",
  database: "conduit",
  user: "postgres",
  password: "abc"
)

module Conduit
  class API < Grape::API
    format :json
    get :hello do
      DB[:new_table].first
    end
  end
end
