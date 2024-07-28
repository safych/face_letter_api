class CreateUserLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :user_links do |t|
      t.references :user, null: false, foreign_key: true
      t.string :url,      null: false, default: ""

      t.timestamps
    end
  end
end
