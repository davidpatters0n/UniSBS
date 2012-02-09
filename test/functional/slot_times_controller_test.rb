require 'test_helper'

class SlotTimesControllerTest < ActionController::TestCase
  setup do
    @slot_time = slot_times(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:slot_times)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create slot_time" do
    assert_difference('SlotTime.count') do
      post :create, slot_time: @slot_time.attributes
    end

    assert_redirected_to slot_time_path(assigns(:slot_time))
  end

  test "should show slot_time" do
    get :show, id: @slot_time.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @slot_time.to_param
    assert_response :success
  end

  test "should update slot_time" do
    put :update, id: @slot_time.to_param, slot_time: @slot_time.attributes
    assert_redirected_to slot_time_path(assigns(:slot_time))
  end

  test "should destroy slot_time" do
    assert_difference('SlotTime.count', -1) do
      delete :destroy, id: @slot_time.to_param
    end

    assert_redirected_to slot_times_path
  end
end
