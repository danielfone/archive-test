class CreateBoolWidgets < ActiveRecord::Migration
  def change
    create_table :bool_widgets do |t|
      t.string :name
      t.boolean :archived

      t.timestamps
    end
    add_index :bool_widgets, :archived
  end
end
