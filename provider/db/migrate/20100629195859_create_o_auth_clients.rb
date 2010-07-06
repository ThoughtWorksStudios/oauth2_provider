class CreateOAuthClients < ActiveRecord::Migration
  def self.up
    create_table :o_auth_clients do |t|
      t.string :name
      t.string :client_id
      t.string :client_secret
      t.string :redirect_uri

      t.timestamps
    end
  end

  def self.down
    drop_table :o_auth_clients
  end
end
