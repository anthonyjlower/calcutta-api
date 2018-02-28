class BidController < ApplicationController

	get	'/' do
		@bids = Bid.all

		resp = {
			status: 200,
			bids: @bids
		}
		resp.to_json
	end
end