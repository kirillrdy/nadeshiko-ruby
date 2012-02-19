class CreateTasks < ActiveRecord::Migration
   def self.up

    create_table :tasks do |t|
      t.string :description
      t.integer :assigned_to
      t.string :status
      t.string :task_type
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

    create_table :projects do |t|
      t.string :name
    end

    create_table :project_users do |t|
      t.integer :project_id
      t.integer :user_id
    end

  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
