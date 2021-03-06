require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: 'Maki Nishikino', email: 'maki@example.com',
                     password: 'nikonikoni', password_confirmation: 'nikonikoni')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '  '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '  '
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should accept addresses of length 255' do
    @user.email = '@example.com'.rjust(255, 'a')
    assert @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w{user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn}
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid? "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w{user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com}
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid? "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    assert duplicate_user.valid?
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email addresses should be saved as lower-case' do
    mixedcase_email = 'Foo@ExAMPle.CoM'
    downcase_email = mixedcase_email.downcase

    @user.email = mixedcase_email
    @user.save
    assert_equal downcase_email, @user.reload.email
  end

  test 'password should be present' do
    @user.password = @user.password = ' ' * 8
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with nil remember_digest' do
    assert_not @user.authenticated?(:remember, 'test-digest')
  end

  test 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'Lotem ipsum')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'should follow and unfollow a user' do
    michael = users(:michael)
    archer = users(:archer)

    assert_not michael.following?(archer), 'michael should not be following archer'
    assert_not archer.followed_by?(michael), 'archer should not be followed by michael'
    michael.follow(archer)
    assert michael.following?(archer), 'michael should be following archer'
    assert archer.followed_by?(michael), 'archer should be followed by michael'
    michael.unfollow(archer)
    assert_not michael.following?(archer), 'michael should not be following archer'
    assert_not archer.followed_by?(michael), 'archer should not be followed by michael'
  end

  test 'feed should have the right posts' do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)

    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following), 'feed for michael should include lana\'s micropost'
    end
    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self), 'feed for michael should include michael\'s micropost'
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed), 'feed for michael should not include archer\'s micropost'
    end
  end

  test 'feed should include starred posts regardless of relationship' do
    travel_to(Time.zone.local 2015, 9, 10, 10) do
      archer = users(:archer)
      michael = users(:michael)

      post_starred = archer.microposts.create(content: 'This is starred!', starred: true)

      assert archer.star?
      assert_not michael.following?(archer), "michael follows archer"
      assert michael.feed.include?(post_starred), "starred post not included"
    end
  end

  test "should fetch the stars" do
    stars = User.current_stars(Date.new(2015, 9, 10))
    assert stars.member?(stars(:archer0).user)
  end

  test "current_stars should not include un-activated users" do
    user = stars(:archer0).user
    user.activated = false
    user.activated_at = nil

    user.save

    stars = User.current_stars(Date.new(2015, 9, 10))
    assert_not stars.member?(user)
  end

  test 'star' do
    today = DateTime.new(1950, 2, 10)
    now = Time.zone.local(1950, 2, 10, 10, 45, 11)
    lana = users(:lana)

    assert_not lana.star?

    star = lana.stars.create(date: today, status: :candidate)
    assert_not lana.star?(now)

    star.update(status: :accepted)
    assert lana.star?(now)
    assert_not lana.star?(1.day.ago(now))

    star.update(status: :declined)
    assert_not lana.star?(now)
  end

  test 'star_status' do
    today = DateTime.new(1950, 2, 10)
    now = Time.zone.local(1950, 2, 10, 10, 45, 11)
    lana = users(:lana)

    assert_nil lana.star_status(now)

    star = lana.stars.create(date: today, status: :candidate)
    assert_equal :candidate, lana.star_status(now)

    star.update(status: :accepted)
    assert lana.star?(now)
    assert_equal :accepted, lana.star_status(now)

    star.update(status: :declined)
    assert_equal :declined, lana.star_status(now)
  end
end
