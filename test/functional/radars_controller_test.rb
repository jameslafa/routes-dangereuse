require 'test_helper'

class RadarsControllerTest < ActionController::TestCase
  setup do
    @radar = radars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:radars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create radar" do
    assert_difference('Radar.count') do
      post :create, radar: { latitude: @radar.latitude, longitude: @radar.longitude, type: @radar.type }
    end

    assert_redirected_to radar_path(assigns(:radar))
  end

  test "should show radar" do
    get :show, id: @radar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @radar
    assert_response :success
  end

  test "should update radar" do
    put :update, id: @radar, radar: { latitude: @radar.latitude, longitude: @radar.longitude, type: @radar.type }
    assert_redirected_to radar_path(assigns(:radar))
  end

  test "should destroy radar" do
    assert_difference('Radar.count', -1) do
      delete :destroy, id: @radar
    end

    assert_redirected_to radars_path
  end
end
