class Invite < ActiveRecord::Base
	has_one :user
	has_one :pool	
end