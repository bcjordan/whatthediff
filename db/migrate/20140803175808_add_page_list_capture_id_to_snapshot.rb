class AddPageListCaptureIdToSnapshot < ActiveRecord::Migration
  def change
    add_column :snapshots, :page_list_capture_id, :integer
  end
end
