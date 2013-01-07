require 'test_helper'

class AccidentsControllerTest < ActionController::TestCase
  setup do
    @accident = accidents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accidents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create accident" do
    assert_difference('Accident.count') do
      post :create, accident: { atmospherique: @accident.atmospherique, codeinsee: @accident.codeinsee, collision: @accident.collision, gravite: @accident.gravite, hospitalises: @accident.hospitalises, indemnes: @accident.indemnes, intersection: @accident.intersection, latitude: @accident.latitude, leger: @accident.leger, longitude: @accident.longitude, lumiere: @accident.lumiere, numac: @accident.numac, route: @accident.route, tues: @accident.tues, ville: @accident.ville }
    end

    assert_redirected_to accident_path(assigns(:accident))
  end

  test "should show accident" do
    get :show, id: @accident
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @accident
    assert_response :success
  end

  test "should update accident" do
    put :update, id: @accident, accident: { atmospherique: @accident.atmospherique, codeinsee: @accident.codeinsee, collision: @accident.collision, gravite: @accident.gravite, hospitalises: @accident.hospitalises, indemnes: @accident.indemnes, intersection: @accident.intersection, latitude: @accident.latitude, leger: @accident.leger, longitude: @accident.longitude, lumiere: @accident.lumiere, numac: @accident.numac, route: @accident.route, tues: @accident.tues, ville: @accident.ville }
    assert_redirected_to accident_path(assigns(:accident))
  end

  test "should destroy accident" do
    assert_difference('Accident.count', -1) do
      delete :destroy, id: @accident
    end

    assert_redirected_to accidents_path
  end
end
