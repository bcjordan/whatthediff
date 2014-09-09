require 'test_helper'

class PageListsControllerTest < ActionController::TestCase
  setup do
    @page_list = page_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:page_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page_list" do
    assert_difference('PageList.count') do
      post :create,
           page_list: {email: 'testing@brian.com'},
           url_list: 'http://google.com
                      http://whadap.com'
    end

    page_list = assigns(:page_list)
    assert_not_empty(page_list.pages)
    assert_redirected_to trigger_list_capture_url(page_list)
  end

  test "should show page_list" do
    get :show, id: @page_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @page_list
    assert_response :success
  end

  test "should update page_list" do
    patch :update, id: @page_list, page_list: {  }
    assert_redirected_to page_list_path(assigns(:page_list))
  end

  test "should destroy page_list" do
    assert_difference('PageList.count', -1) do
      delete :destroy, id: @page_list
    end

    assert_redirected_to page_lists_path
  end
end
