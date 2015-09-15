require 'test_helper'

class Api::StardomControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
    @request.headers["Authorization"] = token_for(@user)

    @today = DateTime.new(1950, 2, 10)
    @now = Time.zone.local(1950, 2, 10, 10, 45, 11)
  end

  test 'show should require authentication' do
    @request.headers["Authorization"] = nil
    get :show, format: :json
    assert_equal 401, response.status
  end

  test 'when there are no stars' do
    travel_to(@now) do
      get :show, format: :json
    end
    assert_equal 200, response.status

    json = JSON.parse(response.body)
    assert_kind_of Hash, json

    assert_equal false, json['active']
    assert json.has_key?('star_status')
    assert_nil json['star_status']
    assert_equal @now.to_date, json['date'].to_date
  end

  test 'when there are some stars' do
    users(:archer).stars.create(date: @today, status: :accepted)

    travel_to(@now) do
      get :show, format: :json
    end
    assert_equal 200, response.status

    json = JSON.parse(response.body)
    assert_kind_of Hash, json

    assert_equal true, json['active']
    assert json.has_key?('star_status')
    assert_equal 'stargazer', json['star_status']
    assert_equal @now.to_date, json['date'].to_date
  end

  test 'when you are a candidate star' do
    @user.stars.create(date: @today, status: :candidate)

    travel_to(@now) do
      get :show, format: :json
    end
    assert_equal 200, response.status

    json = JSON.parse(response.body)
    assert_kind_of Hash, json

    assert_equal true, json['active']
    assert_equal 'candidate', json['star_status']
    assert_equal @now.to_date, json['date'].to_date
  end

  test 'when you are a star' do
    @user.stars.create(date: @today, status: :accepted)

    travel_to(@now) do
      get :show, format: :json
    end
    assert_equal 200, response.status

    json = JSON.parse(response.body)
    assert_kind_of Hash, json

    assert_equal true, json['active']
    assert_equal 'accepted', json['star_status']
    assert_equal @now.to_date, json['date'].to_date
  end

  test 'when you have declined to be a star' do
    @user.stars.create(date: @today, status: :declined)

    travel_to(@now) do
      get :show, format: :json
    end
    assert_equal 200, response.status

    json = JSON.parse(response.body)
    assert_kind_of Hash, json

    assert_equal true, json['active']
    assert_equal 'declined', json['star_status']
    assert_equal @now.to_date, json['date'].to_date
  end

  test 'update should require authentication' do
    @request.headers["Authorization"] = nil
    patch :update, format: :json
    assert_equal 401, response.status
  end

  test 'update for non-candidate user' do
    travel_to(@now) do
      patch :update, stardom: {accept: 'true'}, format: :json
    end

    assert_equal 403, response.status
  end

  test 'accept a star' do
    star = @user.stars.create(date: @today, status: :candidate)

    travel_to(@now) do
      patch :update, stardom: {accept: 'true'}, format: :json
    end

    assert_equal 200, response.status
    assert_equal :accepted, star.reload.status
  end

  test 'decline a star' do
    star = @user.stars.create(date: @today, status: :candidate)

    travel_to(@now) do
      patch :update, stardom: {accept: 'false'}, format: :json
    end

    assert_equal 200, response.status
    assert_equal :declined, star.reload.status
  end

  test 'update with invalid value 1' do
    star = @user.stars.create(date: @today, status: :candidate)

    travel_to(@now) do
      patch :update, stardom: {accept: '1'}, format: :json
    end

    assert_equal 400, response.status
    assert_equal :candidate, star.reload.status
  end

  test 'update with invalid value 2' do
    star = @user.stars.create(date: @today, status: :candidate)

    travel_to(@now) do
      patch :update, format: :json
    end

    assert_equal 400, response.status
    assert_equal :candidate, star.reload.status
  end
end
