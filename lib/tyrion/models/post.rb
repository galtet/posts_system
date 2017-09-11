require 'date'

module Tyrion
	module Models
		class Post < ActiveRecord::Base
			belongs_to :user
			has_many :votes

      after_create :update_hot_posts

      MAX_HOT_POSTS = 3
      @@hot_posts = []

      def self.hot_posts
        @@hot_posts ||= []
      end

      def self.set_hot_posts(h_posts)
        @@hot_posts = h_posts
      end

      def upvote(user_id)
        self.votes.create(vote: '1', user_id: user_id)
      end

      def downvote(user_id)
        self.votes.create(vote: '0', user_id: user_id)
      end

      def update_hot_posts()
        return if self.class.hot_posts.any? { |p| p.id == self.id }
        if self.class.hot_posts.length < MAX_HOT_POSTS
          self.class.hot_posts << self
        else
          self.class.hot_posts << self
          res = self.class.hot_posts.sort_by do |p|
            p.hot_score
          end
          self.class.set_hot_posts(res.last(MAX_HOT_POSTS))
        end
      end

      def hot_score
        hot(self.votes.where(vote: '1').count, self.votes.where(vote: '0').count, self.created_at.to_time)
      end

      private


			# Actually doesn't matter WHAT you choose as the epoch, it
			# won't change the algorithm. Just don't change it after you
			# have cached computed scores. Choose something before your first
			# post to avoid annoying negative numbers. Choose something close
			# to your first post to keep the numbers smaller. This is, I think,
			# reddit's own epoch.
			def epoch_seconds(t)
				epoch = Time.local(2017, 9, 10, 23, 46, 43).to_time
				(t.to_i - epoch.to_i).to_f
			end


			# date is a ruby Time
			def hot(ups, downs, date)
				s = ups - downs
				displacement = Math.log( [s.abs, 1].max,  10 )

				sign = if s > 0
								 1
							 elsif s < 0
								 -1
							 else
								 0
							 end

				return (displacement * sign.to_f) + ( epoch_seconds(date) / 45000 )
			end
		end
	end
end
