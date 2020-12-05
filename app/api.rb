require 'grape'

module Conduit
  class API < Grape::API
    get :hello do
      { 'hello': 'world' }
    end
  end
end
