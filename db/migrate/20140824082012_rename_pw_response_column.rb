class RenamePwResponseColumn < ActiveRecord::Migration
  def change
    rename_column :pw_responses, :escaped_password, :encrypted_password
  end
end
