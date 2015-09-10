require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: 'Lorem ipsum')
  end

  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'content should be present' do
    @micropost.content = '  '
    assert_not @micropost.valid?
  end

  test 'content should be at most 140 caracters' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  test 'order should be most recent first' do
    assert_equal microposts(:most_recent), Micropost.first
  end

  test "picture_url" do
    micropost = microposts(:orange)

    assert_match /^https:\/\//, micropost.picture_url
  end

  test 'starred posts' do
    today = DateTime.new(1950, 2, 10)
    now = Time.zone.local(1950, 2, 10, 10, 45, 11)

    user = users(:lana)
    star = user.stars.create(date: today, status: :accepted)

    travel_to(now) do
      micropost = user.microposts.create(content: 'Hi!')
      assert micropost.starred?
    end

    travel_to(1.days.ago(now)) do
      micropost = user.microposts.create(content: 'Hi!')
      assert_not micropost.starred?
    end

    star.update(status: :candidate)
    travel_to(now) do
      micropost = user.microposts.create(content: 'Hi!')
      assert_not micropost.starred?
    end

    star.update(status: :declined)
    travel_to(now) do
      micropost = user.microposts.create(content: 'Hi!')
      assert_not micropost.starred?
    end
  end
end
