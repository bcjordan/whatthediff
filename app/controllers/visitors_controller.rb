class VisitorsController < ApplicationController
  def index
    @page_list = PageList.new
  end
end
