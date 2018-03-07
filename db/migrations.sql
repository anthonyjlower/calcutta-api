DROP DATABASE IF EXISTS calcutta; 

CREATE DATABASE calcutta;

\c calcutta;

CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255)
);

CREATE TABLE pools(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	owner INT references users(id)
);

CREATE TABLE invites(
	id SERIAL PRIMARY KEY,
	pool_id INT references pools(id),
	user_id INT references users(id),
	accepted BOOLEAN
);

CREATE TABLE teams(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	seed INT,
	season_wins INT,
	season_losses INT,
	current_winnings DECIMAL,
	still_alive BOOLEAN
);

CREATE TABLE bids(
	id SERIAL PRIMARY KEY,
	pool_id INT references pools(id),
	user_id INT references users(id),
	team_id INT references teams(id), 
	bid_amount DECIMAL
);
