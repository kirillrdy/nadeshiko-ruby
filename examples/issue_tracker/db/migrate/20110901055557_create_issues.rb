class CreateIssues < ActiveRecord::Migration
   def self.up
    create_table :issues do |t|
      t.string :description
      t.boolean :finished
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
