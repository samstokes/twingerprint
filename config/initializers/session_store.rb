# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twingerprint_session',
  :secret      => '40fa8b67b420c762162fc9023f557759e50a00c387f0a3bed5607418f2983df2450af0ceb7bdf4b61a103f398adebe561c00be3b79c79c2d15972d81386daae3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
