class AddPageListCaptureIdToDiff < ActiveRecord::Migration
  def change
    add_column :diffs, :page_list_capture_id, :integer
  end
end
