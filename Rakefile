# frozen_string_literal: true

# Borrowed from https://gist.github.com/viking/1133150/255ae41ead3b2668542a2b3fe7ef7fea95742166

namespace :bundler do
  task :setup do
    require 'rubygems'
    require 'bundler/setup'
  end
end

task :environment, [:env] => 'bundler:setup' do |_cmd, args|
  ENV['RACK_ENV'] = args[:env] || 'development'
  require './db/database'
end

namespace :db do
  desc 'Run database migrations'
  task :migrate, :env do |_cmd, args|
    env = args[:env] || 'development'
    Rake::Task['environment'].invoke(env)

    require 'sequel/extensions/migration'
    Sequel::Migrator.apply(Database.instance.conn, './db/migrations')
  end

  desc 'Nuke the database (drop all tables)'
  task :nuke, :env do |_cmd, args|
    env = args[:env] || 'development'
    Rake::Task['environment'].invoke(env)
    Database.instance.conn.tables.each do |table|
      Database.instance.conn.run("DROP TABLE #{table}")
    end
  end

  desc 'Reset the database'
  task :reset, [:env] => %i[nuke migrate]
end
