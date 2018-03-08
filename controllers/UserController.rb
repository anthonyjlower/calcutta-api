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
		
	end


	# Get summary and pool information for the logged in user
	get '/:id' do

		user = User.find(params[:id])
		pools = user.pools

		user_bets = 0
		user_winnings = 0
		poolArr = []

		# For each pool find; how much the user has bet, How much the user has won
		pools.each{ |pool|
			pool_pot = 0
			user_pool_bets = 0
			user_pool_winnings = 0

			# Calc the size of this pools total pot
			pool.bids.each{ |bid| pool_pot += bid.bid_amount}

			# Go through each team's bid in the pot		
			Team.all.each{ |team| 
				
				
				bid = team.bids.where(pool_id: pool.id)
		
				# If the team is owned by the user
				if bid.length != 0 && bid[0].user_id === user.id
				
					# Add their bid amount to the totals
					user_pool_bets += bid[0].bid_amount
					user_bets += bid[0].bid_amount

					# Calc their winnings and add it to the totals
					teamWinnings = pool_pot * team.current_winnings
					user_pool_winnings += teamWinnings
					user_winnings += teamWinnings
				end
			}

			pool = {
				name: pool.name,
				id: pool.id,
				user_bets: user_pool_bets,
				user_winnings: user_pool_winnings
			}
			poolArr.push(pool)
		}

		resp = {
			status: 200,
			message: "Here is the info for user #{user.name}",
			data: {
				user: user,
				number_of_pools: pools.length,
				total_bet: user_bets,
				total_won: user_winnings,
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

	post '/login' do
		user = User.find_by(name: params[:username])

		session[:user_id] = user.id

		resp = {
			status: 200,
			message: "#{user.name} is logged in",
			data: {
				user: user
			}
		}
		resp.to_json
	end

end