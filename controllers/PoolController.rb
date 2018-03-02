class PoolController < ApplicationController

	get "/all" do
		@pools = Pool.all

		resp = {
			status: 200,
			pools: @pools
		}
		resp.to_json
	end


	get '/test/:id' do
		# Get the pool info
		pool = Pool.find(params[:id])
		# Get all of the users in the pool
		pool_members = pool.users
		teamArr = []
		
		# Get all of the Teams in the pool
		teams = Team.all
		# Loop through each team in the array
		teams.each{ |team| 
			# Find that teams bid in this pool
			bid = team.bids.find_by(pool_id: params[:id])
			# Get the user that placed the bid
			user = User.find(bid.user_id)

			# create new team hash
			team = {
				name: team.name,
				seed: team.seed,
				season_wins: team.season_wins,
				season_losses: team.season_losses,
				tourney_wins: team.tourney_wins,
				still_alive: team.still_alive,
				bid: {
					amount: bid.bid_amount,
					username: user.name
				}
			}
			# Push hash into the array
			teamArr.push(team)
		}

		resp = {
			pool: pool,
			pool_members: pool_members,
			teams: teamArr
		}
		resp.to_json

	end

	get '/:id' do
		# Get the pool info
		pool = Pool.find(params[:id])
		# Get all of the users in the pool
		pool_members = pool.users
		teamArr = []
		
		# Get all of the Teams in the pool
		teams = Team.all
		# Loop through each team in the array
		teams.each{ |team| 
			# Find that teams bid in this pool
			bid = team.bids.find_by(pool_id: params[:id])
			# Get the user that placed the bid
			user = User.find(bid.user_id)

			# create new team hash
			team = {
				name: team.name,
				seed: team.seed,
				season_wins: team.season_wins,
				season_losses: team.season_losses,
				tourney_wins: team.tourney_wins,
				still_alive: team.still_alive,
				bid: {
					amount: bid.bid_amount,
					username: user.name
				}
			}
			# Push hash into the array
			teamArr.push(team)
		}

		resp = {
			status: 200,
			message: "Pool #{pool.id} info, pool's user info, pool's bid info, team info",
			data: {
				pool: pool,
				pool_members: pool_members,
				teams: teamArr
			}
		}
		resp.to_json

	end

	post '/' do
		# Create new pool
		@pool = Pool.new
		@pool.name = params[:name]
		@pool.owner = params[:user_id]
		@pool.save

		# Create an invite to link the user with the pool
		@pool.invites.create(user_id: params[:user_id], accepted: true)

		# Find all of that user's pools
		@pools = User.find(params[:user_id]).pools

		resp = {
			status: 200,
			message: "Created #{@pool.name}",
			data: {
				pools: @pools,
				number_of_pools: @pools.length
			}
		}
		resp.to_json
	end

	post '/invite' do
		@pool = Pool.find(params[:pool_id])
		@user = User.find_by(name: params[:username])
		@invite = @pool.invites.create(user_id: @user.id, accepted: true)

		@pool_members = @pool.users
		@pool_bids = @pool.bids
		@teams = Team.all

		resp = {
			status: 200,
			message: "Invited #{@user.name} to #{@pool.name} ",
			data: {
				pool: @pool,
				users: @pool_members,
				bids: @pool_bids,
				teams: @teams	
			}
		}
		resp.to_json
	end

	post '/bid' do
		# Get the pool doing the auction
		@pool = Pool.find(params[:pool_id])
		# Find the user_id of the winning bidder
		@user = User.find_by(name: params[:username])
		# Create the bid
		@pool.bids.create(user_id: @user.id, team_id: params[:team_id], bid_amount: params[:amount])

		@pool_members = @pool.users
		@pool_bids = @pool.bids
		@teams = Team.all

		resp = {
			status: 200,
			message: "Submitted #{@user.name}'s bid",
			data: {
				pool: @pool,
				users: @pool_members,
				bids: @pool_bids,
				teams: @teams	
			}
		}
		resp.to_json

	end

	get '/bids' do
		@bids = Pool.find(1).bids

		resp = {
			status: 200,
			number_of_bids: @bids.length,
			bids: @bids
		}
		resp.to_json
	end



end