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

	get '/test' do

		@user = User.find(1)
		@pools = @user.pools
		poolArr = []

		@pools.each { |pool|
			bids = pool.bids.where(user_id: 1)
			sum_of_bids = 0
			bids.each{ |bid| sum_of_bids += bid.bid_amount}

			pool = {
				name: pool.name,
				id: pool.id,
				number_of_bids: bids.length,
				sum_of_bids: sum_of_bids,
				bids: bids
			}
			poolArr.push(pool)
		}

		resp = {
			user: @user,
			pools: poolArr
		}
		resp.to_json

	end


	# Get invite and pool information for the logged in user
	get '/' do
		# Find the user
		@user = User.find(1)
		# Find all of the user's bids
		@user_bids = @user.bids

		# Find the sum of all of the user's bids
		sum_of_user_bids = 0
		@user_bids.each{ |bid| sum_of_user_bids += bid.bid_amount}

		# Find all of the user's pools
		@pools = @user.pools
		# Create empty array to hold all of the pools
		poolArr = []

		# Loop through all of the pools
		@pools.each { |pool|
			# Find all of the bids in a pool that belong to the user
			bids = pool.bids.where(user_id: 1)

			# Find the sum of the pool specific bids
			sum_of_bids = 0
			bids.each{ |bid| sum_of_bids += bid.bid_amount}

			# Create the new pool hash
			pool = {
				name: pool.name,
				id: pool.id,
				number_of_bids: bids.length,
				sum_of_bids: sum_of_bids,
				bids: bids
			}
			# Push the pool hash into the array
			poolArr.push(pool)
		}

		# build response
		resp = {
			status: 200,
			message: "Here is the info for user #{@user.name}",
			data: {
				user: @user,
				number_of_pools: @pools.length,
				total_bet: sum_of_user_bids,
				pools: poolArr
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