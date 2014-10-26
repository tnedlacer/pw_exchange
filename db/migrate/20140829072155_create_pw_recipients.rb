class CreatePwRecipients < ActiveRecord::Migration
  def change
    create_table :pw_recipients do |t|
      t.belongs_to :pw_sender, index: true
      t.string :email

      t.timestamps
    end
  end
end
