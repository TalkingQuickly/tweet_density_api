class CreateTrackedTags < ActiveRecord::Migration
  def change
    create_table :tracked_tags do |t|
      t.string :term
      t.boolean :current

      t.timestamps
    end
  end
end
