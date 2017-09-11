module Tyrion
  module Models
    class User < ActiveRecord::Base
      has_many :posts
      has_many :votes
    end
  end
end
