class PoolController < ApplicationController

	get '/test' do
		binding.pry
	end


	get "/all" do
		@pools = Pool.all

		resp = {
			status: 200,
			pools: @pools
		}
		resp.to_json
	end

	get '/:id' do
		# Get the pool info
		pool = Pool.find(params[:id])
		# Get all of the users in the pool
		pool_members = pool.users

		number_of_bids = pool.bids.length
		
		teamArr = []
		pot_size = 0

		# Sum the bid values
		pool.bids.each{ |bid|
			pot_size += bid.bid_amount
		}
		
		# Get all of the Teams in the pool
		teams = Team.all
		# Loop through each team in the array
		teams.each{ |team| 
			# Find that teams bid in this pool
			bid = team.bids.find_by(pool_id: params[:id])

			# If bid value is nil
			if bid == nil
				team = {
				name: team.name,
				seed: team.seed,
				season_wins: team.season_wins,
				season_losses: team.season_losses,
				winnings: team.current_winnings,
				still_alive: team.still_alive,
				bid: {
					amount: 0,
					username: "Not Owned"
				}
			}
			# Push hash into the array
			teamArr.push(team)

			else
				# Calculate the team's winnings
				winnings = team.current_winnings * pot_size

				# Get the user that placed the bid
				user = User.find(bid.user_id)

				# create new team hash
				team = {
					name: team.name,
					seed: team.seed,
					season_wins: team.season_wins,
					season_losses: team.season_losses,
					winnings: winnings,
					still_alive: team.still_alive,
					bid: {
						amount: bid.bid_amount,
						username: user.name
					}
				}
				# Push hash into the array
				teamArr.push(team)
			end
		}
			
		resp = {
			status: 200,
			message: "Pool #{pool.id} info, pool's user info, pool's bid info, team info",
			data: {
				pool: pool,
				number_of_bids: number_of_bids,
				pot_size: pot_size,
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

		# Create invite to link the pool with the creating user
		@pool.invites.create({user_id: params[:user_id], accepted: true})

		# Find the user
		@user = User.find(params[:user_id])
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


	# Invite user to a pool
	post '/invite' do
		# Find the pool the invite will belong to you
		pool = Pool.find(params[:pool_id])
		# Find the user being invited by name
		invitedUser = User.find_by(name: params[:username])
		# Create the invite
		@invite = pool.invites.create(user_id: invitedUser.id, accepted: true)

		
		# Get all of the users in the pool
		pool_members = pool.users
		
		teamArr = []
		pot_size = 0
		
		# Get all of the Teams in the pool
		teams = Team.all
		# Loop through each team in the array
		teams.each{ |team| 
			# Find that teams bid in this pool
			bid = team.bids.find_by(pool_id: params[:id])

			# If bid value is nil
			if bid == nil
				team = {
				name: team.name,
				seed: team.seed,
				season_wins: team.season_wins,
				season_losses: team.season_losses,
				tourney_wins: team.tourney_wins,
				still_alive: team.still_alive,
				bid: {
					amount: 0,
					username: "Not Owned"
				}
			}
			# Push hash into the array
			teamArr.push(team)

			else
				# Sum the bid values
				pot_size += bid.bid_amount

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
			end
		}
			
		resp = {
			status: 200,
			message: "Pool #{pool.id} info, pool's user info, pool's bid info, team info",
			data: {
				pool: pool,
				pot_size: pot_size,
				pool_members: pool_members,
				teams: teamArr
			}
		}
		resp.to_json

	end


	post '/bid' do
		# Get the pool doing the auction
		pool = Pool.find(params[:pool_id])
		# Find the user_id of the winning bidder
		bidding_user = User.find_by(name: params[:username])
		# Create the bid
		new_bid = pool.bids.create(user_id: bidding_user.id, team_id: params[:team_id], bid_amount: params[:amount])
		'-------New Bid------------'
		p new_bid

		# Get all of the users in the pool
		pool_members = pool.users

		number_of_bids = pool.bids.length
		
		teamArr = []
		pot_size = 0

		# Sum the bid values
		pool.bids.each{ |bid|
			pot_size += bid.bid_amount
		}
		
		# Get all of the Teams in the pool
		teams = Team.all
		# Loop through each team in the array
		teams.each{ |team| 
			p '------------Team Array-----------'
			p teamArr


			# Find that teams bid in this pool
			bid = team.bids.find_by(pool_id: pool.id)

			# If bid value is nil
			if bid == nil
				team = {
				name: team.name,
				seed: team.seed,
				season_wins: team.season_wins,
				season_losses: team.season_losses,
				winnings: team.current_winnings,
				still_alive: team.still_alive,
				bid: {
					amount: 0,
					username: "Not Owned"
				}
			}
			# Push hash into the array
			teamArr.push(team)

			else
				# Calculate the team's winnings
				winnings = team.current_winnings * pot_size

				# Get the user that placed the bid
				user = User.find(bid.user_id)

				# create new team hash
				team = {
					name: team.name,
					seed: team.seed,
					season_wins: team.season_wins,
					season_losses: team.season_losses,
					winnings: winnings,
					still_alive: team.still_alive,
					bid: {
						amount: bid.bid_amount,
						username: user.name
					}
				}
				# Push hash into the array
				teamArr.push(team)
			end
		}
			
		resp = {
			status: 200,
			message: "Pool #{pool.id} info, pool's user info, pool's bid info, team info",
			data: {
				pool: pool,
				number_of_bids: number_of_bids,
				pot_size: pot_size,
				pool_members: pool_members,
				teams: teamArr
			}
		}
		resp.to_json
		
	end

end