class BidController < ApplicationController

	get	'/:id' do
		pool = Pool.find(params[:id])
		bids = pool.bids
		bids.to_json
	end

end