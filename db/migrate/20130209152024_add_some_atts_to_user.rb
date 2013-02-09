class AddSomeAttsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :poids, :integer
    add_column :users, :poids_ideal, :integer
    add_column :users, :date, :text
    add_column :users, :fumeur, :boolean
    add_column :users, :aret, :boolean
  end

  def self.down
    remove_column :users, :aret
    remove_column :users, :fumeur
    remove_column :users, :date
    remove_column :users, :poids_ideal
    remove_column :users, :poids
  end
end
