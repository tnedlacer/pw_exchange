class CreatePwRequests < ActiveRecord::Migration
  def change
    create_table :pw_requests do |t|
      t.string :password_digest
      t.string :email
      t.string :list_token
      t.string :form_token
      t.text :input_options

      t.timestamps
    end
    add_index :pw_requests, :password_digest, unique: true
    add_index :pw_requests, :list_token, unique: true
    add_index :pw_requests, :form_token, unique: true
  end
end
