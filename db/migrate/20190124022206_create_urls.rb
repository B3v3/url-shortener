class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :link
      t.string :shortening
      t.integer :days_to_delete

      t.timestamps
    end
    add_index :urls, :shortening
  end
end
