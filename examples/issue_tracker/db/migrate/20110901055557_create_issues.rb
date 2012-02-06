class CreateIssues < ActiveRecord::Migration
   def self.up

    create_table :issues do |t|
      t.string :description
      t.boolean :finished
    end

    create_table :order_scopes do |t|
      t.string :name
      t.string :data
    end

  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
