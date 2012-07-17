class Micropost < ActiveRecord::Base
	attr_accessible :content, :in_reply_to
	
	belongs_to :user
	
	validates :content, :presence => true, :length => { :maximum => 140 }
	validates :user_id, :presence => true
	before_save :at_reply
	
  default_scope :order => 'microposts.created_at DESC'

  # Return microposts from the users being followed by the given user.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
	
	scope :including_replies, lambda { |user| replying_to(user) }
	
	private

    # Return an SQL condition for users followed by the given user.
    # We include the user's own id as well.
		def self.followed_by(user)
      following_ids = %(SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id)
      where("user_id IN (#{following_ids}) OR user_id = :user_id",
            { :user_id => user })
    end
		
		def self.replying_to(user)
		 	replies_to = %(SELECT in_reply_to FROM microposts
		 								 WHERE in_reply_to = :user_id) 
			where("user_id IN (#{replies_to})", { :user_id => user })
		end
		
				
		def at_reply
			at_reply_regex = /^\A[\@][\w]{1,15}\b/
		
			if self =~ at_reply_regex
				reply_to_user = at_reply_regex[1..-1]
				reply_to_username = User.find_by_username(reply_to_user)
				user_id = reply_to_username[:id]
				self.merge(:in_reply_to => user_id)
			end
		end
end