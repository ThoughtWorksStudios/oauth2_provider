class CreateOauthTokensTable < ActiveRecord::Migration
  def self.up
    create_table :oauth_tokens do |t|
      t.string :user_id
      t.integer :oauth_client_id
      t.string :authorization_code
      
      t.string :access_token
      t.string :refresh_token
      t.timestamp :expires_at
      
      t.timestamps
    end
    
  end

  def self.down
    
  end

end
