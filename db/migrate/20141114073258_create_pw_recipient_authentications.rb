class CreatePwRecipientAuthentications < ActiveRecord::Migration
  def change
    create_table :pw_recipient_authentications do |t|
      t.belongs_to :pw_recipient, index: true
      t.string :session_id, index: true
      t.string :password_digest

      t.timestamps
    end
  end
end
