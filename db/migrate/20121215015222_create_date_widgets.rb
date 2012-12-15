class CreateDateWidgets < ActiveRecord::Migration
  def change
    create_table :date_widgets do |t|
      t.string :name
      t.datetime :archived_at

      t.timestamps
    end
    add_index :date_widgets, :archived_at
  end
end