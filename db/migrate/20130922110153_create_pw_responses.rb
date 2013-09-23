class CreatePwResponses < ActiveRecord::Migration
  def change
    create_table :pw_responses do |t|
      t.belongs_to :pw_request, index: true
      t.text :escaped_password
      t.string :remote_ip
      t.text :user_agent
      t.string :code

      t.timestamps
    end
    add_index :pw_responses, :code, unique: true
  end
end
