# calcutta-api

This is the backend to the a calcutta manager. It receives paramaters in form style API requests and stores data in a PostgreSQL database.

The database uses 5 tables, Users, Pools, and Teams, and then Invites which join Users to Pools, and Bids which join Users Pools, and Teams.

## Routes

### GET /users/:id
Returns all of the data for the a user - generally run on login

### POST /users
Creates a new user

### POST /users/login
Verifies a user login

### GET /users/:user_id/pool/:pool_id
Gets all of a user's data for 1 specific pool

### GET /pools/:id
Gets all of the data for a selected Pool

### POST /pools
Creates a new pool

### POST /pools/invite
Creates and invite linking a user to the pool

### POST /pools/bid
Creeates a bid linking a User to a Team in the pool

## Future Plans
* General routes that return entire database info for more advanced data analysis
* Expanded Teams tables to handle a larger variety of tournaments