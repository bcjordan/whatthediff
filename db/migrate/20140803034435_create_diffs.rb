class CreateDiffs < ActiveRecord::Migration
  def change
    create_table :diffs do |t|

      t.timestamps
    end
  end
end
