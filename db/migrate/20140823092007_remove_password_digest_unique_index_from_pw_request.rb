class RemovePasswordDigestUniqueIndexFromPwRequest < ActiveRecord::Migration
  def up
    remove_index :pw_requests, :password_digest
  end
  def down
    add_index :pw_requests, :password_digest, unique: true
  end
end
