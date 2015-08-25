require 'test_helper'

class Api::FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other = users(:archer)
  end

  test 'follow via api' do
    log_in_as(@user)
    assert_not @user.following?(@other)

    post follow_api_user_path(@other)

    assert @user.following?(@other)
    assert_equal 201, response.status
  end

  test 'unfollow via api' do
    log_in_as(@user)
    @user.follow @other

    assert @user.following?(@other)

    delete follow_api_user_path(@other)

    assert_not @user.following?(@other)
    assert_equal 202, response.status
  end

  test 'follow should return 401 if not logged in' do
    post follow_api_user_path(@other)

    assert 401, response.status
  end

  test 'unfollow should return 401 if not logged in' do
    delete follow_api_user_path(@other)

    assert 401, response.status
  end
end
