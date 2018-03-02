class Bid < ActiveRecord::Base
	belongs_to :pool
	belongs_to :user
	has_one :team
end