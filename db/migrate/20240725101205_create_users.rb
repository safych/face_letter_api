class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name,               null: false, default: ""
      t.string :surname,            null: false, default: ""
      t.string :email,              null: false, default: ""
      t.string :password_digest,    null: false, default: ""

      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      t.string :update_email_token
      t.datetime :update_email_sent_at     

      t.timestamps
    end

    add_index :users, :email,                 unique: true
    add_index :users, :reset_password_token,  unique: true
    add_index :users, :update_email_token,    unique: true
  end
end
