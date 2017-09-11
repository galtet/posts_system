class InitialMigration < ActiveRecord::Migration[5.1]
	def change
		create_table :posts do |t|
      t.string            'user_id'
			t.text              'content'
      t.integer           'upvotes'
      t.integer           'downvotes'
      t.datetime          'created_at'
      t.datetime          'updated_at'
		end

		create_table :users do |t|
      t.string            'username'
      t.datetime          'created_at'
      t.datetime          'updated_at'
		end

		create_table :votes do |t|
      t.string            'user_id'
      t.string            'post_id'
      t.string            'vote'
      t.datetime          'created_at'
      t.datetime          'updated_at'
		end
	end
end

