class CreateCurrentWidgets < ActiveRecord::Migration
  def change
    create_table :current_widgets do |t|
      t.string :name

      t.timestamps
    end
  end
end
