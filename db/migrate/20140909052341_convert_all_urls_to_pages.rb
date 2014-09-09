class ConvertAllUrlsToPages < ActiveRecord::Migration
  def change
    PageList.all.each(&:upgrade_from_legacy)
  end
end
