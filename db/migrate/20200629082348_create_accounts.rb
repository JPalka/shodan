class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :login, null: false
      t.string :password, null: false
      t.references :master_server, null: false, foreign_key: true
      t.integer :premium_points

      t.timestamps
    end
  end
end
