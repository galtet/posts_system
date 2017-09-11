module Tyrion
  module Models
    class Vote < ActiveRecord::Base
      belongs_to :user
      belongs_to :post
      after_create :update_post_score
      validate :one_vote_per_user

      def update_post_score
        self.post.update_hot_posts
      end

      def one_vote_per_user
        if Tyrion::Models::Vote.where(post_id: self.post_id, user_id: self.user_id).any?
          raise "user #{self.user_id} has already voted for post #{self.post_id}"
        end
      end
    end
  end
end
