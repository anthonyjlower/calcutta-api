class UserController < ApplicationController

	# View all users in the system
	get	'/all' do
		@users = User.all

		resp = {
			status: 200,
			message: "Here are all of the users in the db",
			number_of_users: @users.length,
			users: @users
		}
		resp.to_json
	end

	# Get invite and pool information for the logged in user
	get '/' do
		@user = User.find(1)
		@bids = @user.bids
		sum_of_bids = 0
		@bids.each{ |bid| sum_of_bids += bid.bid_amount}


		resp = {
			status: 200,
			message: "Here is the info for user #{@user.name}",
			data: {
				user: @user,
				pools: {
					number_of_pools: @user.pools.length,
					pools: @user.pools
				},
				bids: {
					number_of_bids: @user.bids.length,
					bids: @bids,
					sum_of_bids: sum_of_bids
				}
			}
		}
		resp.to_json
	end

	# Create a new user
	post '/' do
		@user = User.new
		@user.name = params[:name]
		@user.save

		resp = {
			status: 200,
			message: "Created user #{@user.name}",
			user: @user
		}
		resp.to_json
	end

	# Look at a users invites
	get	'/invites' do
		@invites = User.find(1).invites

		resp = {
			status: 200,
			invites: @invites
		}
		resp.to_json
	end

	# Look at a users bids
	get	'/bids' do
		@bids = User.find(1).bids

		resp ={
			status: 200,
			number_of_bids: @bids.length,
			bids: @bids
		}
		resp.to_json
	end


	# Look at a users pools
	get	'/pools' do
		@pools = User.find(1).pools

		resp ={
			status: 200,
			number_of_pools: @pools.length,
			pools: @pools
		}
		resp.to_json
	end





end