class AddTailleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :taille, :integer
  end

  def self.down
    remove_column :users, :taille
  end
end
