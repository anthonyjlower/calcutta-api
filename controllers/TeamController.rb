class TeamController < ApplicationController

	get	'/' do
		@teams = Team.all
		resp = {
			status: {
				success: true,
				message: "These are all of the teams",
				# number_of_teams: @teams.length
			},
			teams: @teams
		}
		resp.to_json
	end

end