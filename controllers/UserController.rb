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


	get '/:user_id/pool/:pool_id' do
		user = User.find(params[:user_id])
		pool = Pool.find(params[:pool_id])

		pot_size = 0
		total_bet = 0
		total_won = 0
		teamArr = []

		# Calculate pot total to do winnings calc
	 	pool.bids.each{ |bid| 
	 		pot_size += bid.bid_amount
	 	}

	 	Team.all.each{ |team |
	 		bid = team.bids.find_by(pool_id: pool.id)

	 		if bid != nil
		 		if bid.user_id === user.id
		 			winnings = team.current_winnings * pot_size
		 			total_bet += bid.bid_amount
		 			total_won += winnings

		 			team = {
		 				name: team.name,
		 				bidAmount: bid.bid_amount,
		 				winnings: winnings
		 			}
		 			teamArr.push(team)	
		 		end
		 	end
	 	}

		resp = {
			status: 200,
			message: "Info for #{user.name} in #{pool.name}",
			data: {
				user: user,
				total_bet: total_bet,
				total_won: total_won,
				teams: teamArr
			}
		}
		resp.to_json
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
		user = User.find_by(name: params[:username])
		if user
			message = 'That username is taken, please pick another'	
			resp = {
				status: 200,
				message: 'Cannot make that user',
				data: {
					userId: "",
					username: '',
					loggedIn: false,
					message: message
				}
			}
			resp.to_json
		else
			newUser = User.new
			newUser.name = params[:username]
			newUser.password = params[:password]
			newUser.save
			resp = {
				status: 200,
				message: '#{newUser.name} has been created',
				data: {
					userId: newUser.id,
					username: newUser.name,
					loggedIn: true,
					message: ""
					}
				}
				resp.to_json
		end
	end

	post '/login' do
		pw = params[:password]
		user = User.find_by(name: params[:username])

		if user && user.authenticate(pw)
			resp = {
				status: 200,
				message: "#{user.name} is logged in",
				data: {
					userId: user.id,
					loggedIn: true,
					message: ""
				}
			}
			resp.to_json
		else
			resp = {
				status: 200,
				message: 'Login failed',
				data: {
					userId: '',
					loggedIn: false,
					message: "Either the username or password was incorrect. Please try again."
				}
			}
			resp.to_json
		end

	end
end