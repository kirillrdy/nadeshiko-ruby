class CreateTasks < ActiveRecord::Migration
   def self.up

    create_table :tasks do |t|
      t.string :description
      t.boolean :finished
    end

    create_table :order_scopes do |t|
      t.string :name
      t.string :data
    end

    create_table :users do |t|
      t.string :name
      t.string :email
    end

  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
