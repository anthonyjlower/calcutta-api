class Pool < ActiveRecord::Base
	belongs_to :user
	has_many :invites
	has_many :users, through: :invites
	has_many :bids
	has_many :teams, through: :bids
end