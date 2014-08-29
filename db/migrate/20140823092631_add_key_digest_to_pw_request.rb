class AddKeyDigestToPwRequest < ActiveRecord::Migration
  def change
    add_column :pw_requests, :key_digest, :string
  end
end
