class Bid < ActiveRecord::Base
	belongs_to :pool
	has_one :user
	has_one :team
end