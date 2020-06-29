class CreateMasterServers < ActiveRecord::Migration[6.0]
  def change
    create_table :master_servers do |t|
      t.string :link, null: false

      t.timestamps
    end
  end
end
