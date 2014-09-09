class PageListsController < ApplicationController
  before_action :set_page_list, only: [:show, :edit, :update, :destroy]

  # GET /page_lists
  # GET /page_lists.json
  def index
    @page_lists = PageList.all
  end

  # GET /page_lists/1
  # GET /page_lists/1.json
  def show
  end

  # GET /page_lists/new
  def new
    @page_list = PageList.new
  end

  # GET /page_lists/1/edit
  def edit
  end

  # POST /page_lists
  # POST /page_lists.json
  def create
    @page_list = PageList.new(page_list_params)
    @page_list.set_urls(params[:url_list])

    respond_to do |format|
      if @page_list.save
        format.html { redirect_to trigger_list_capture_url(@page_list.id), notice: 'Page list was successfully created, taking snapshot' }
        format.json { render :show, status: :created, location: @page_list }
      else
        format.html { render :new }
        format.json { render json: @page_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_lists/1
  # PATCH/PUT /page_lists/1.json
  def update
    respond_to do |format|
      if @page_list.update(page_list_params)
        format.html { redirect_to @page_list, notice: 'Page list was successfully updated.' }
        format.json { render :show, status: :ok, location: @page_list }
      else
        format.html { render :edit }
        format.json { render json: @page_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_lists/1
  # DELETE /page_lists/1.json
  def destroy
    @page_list.destroy
    respond_to do |format|
      format.html { redirect_to page_lists_url, notice: 'Page list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_list
      @page_list = PageList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_list_params
      params.permit(:url_list)
      params[:page_list].permit!
    end
end
