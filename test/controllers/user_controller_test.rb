require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "should get start" do
    get user_start_url
    assert_response :success
  end

  test "should get new" do
    get user_new_url
    assert_response :success
  end

  test "should get remove" do
    get user_remove_url
    assert_response :success
  end

  test "should get login" do
    get user_login_url
    assert_response :success
  end

  test "should get logout" do
    get user_logout_url
    assert_response :success
  end

  test "should get profile" do
    get user_profile_url
    assert_response :success
  end

  test "should get index" do
    get user_index_url
    assert_response :success
  end

  test "should get edit" do
    get user_edit_url
    assert_response :success
  end

end
