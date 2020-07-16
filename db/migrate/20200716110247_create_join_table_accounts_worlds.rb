class CreateJoinTableAccountsWorlds < ActiveRecord::Migration[6.0]
  def change
    create_join_table :accounts, :worlds do |t|
      # t.index [:account_id, :world_id]
      # t.index [:world_id, :account_id]
    end
  end
end
