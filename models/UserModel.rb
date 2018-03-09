class User < ActiveRecord::Base
	has_secure_password
	has_many :invites
	has_many :pools, through: :invites
	has_many :bids
	has_many :teams, through: :bids
end