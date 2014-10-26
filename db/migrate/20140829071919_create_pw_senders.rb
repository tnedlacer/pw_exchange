class CreatePwSenders < ActiveRecord::Migration
  def change
    create_table :pw_senders do |t|
      t.string :form_token
      t.string :key_digest
      t.text :encrypted_password

      t.timestamps
    end
    add_index :pw_senders, :form_token, unique: true
  end
end
