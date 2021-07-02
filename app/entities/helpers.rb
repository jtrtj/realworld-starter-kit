module ApiHelpers
  extend Grape::API::Helpers

  Grape::Entity.format_with :iso_timestamp do |date|
    date&.utc&.iso8601
  end
end
