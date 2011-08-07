class AddedMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :title
    end
  end

  def self.down
  end
end
