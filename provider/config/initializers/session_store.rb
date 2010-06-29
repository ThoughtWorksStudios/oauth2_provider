# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_provider_session',
  :secret      => '6f705fc24bce0b70341e22b4429eb9037f328acea941b6c781bd3c5d2a6ab97bb897ff3bc84f963c2aa7ea167908f6fc3f5fffbce3db3a666ea0dfa7e582c621'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
