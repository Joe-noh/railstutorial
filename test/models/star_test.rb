require 'test_helper'

class StarTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @star = Star.new(user: @user, date: '1985-10-01', status: :accepted)
  end

  test 'status' do
    @star.status = :accepted
    assert @star.valid?
    assert_equal :accepted, @star.status
    assert @star.accepted?
    assert_not @star.declined?
    assert_not @star.candidate?

    # set status by string
    @star.status = 'accepted'
    assert @star.valid?
    assert_equal :accepted, @star.status
    assert @star.accepted?
    assert_not @star.declined?
    assert_not @star.candidate?

    @star.status = :declined
    assert @star.valid?
    assert_equal :declined, @star.status
    assert @star.declined?
    assert_not @star.accepted?
    assert_not @star.candidate?

    @star.status = :candidate
    assert @star.valid?
    assert_equal :candidate, @star.status
    assert @star.candidate?
    assert_not @star.accepted?
    assert_not @star.declined?
  end

  test 'invalid status' do
    @star.status = nil
    assert_not @star.valid?

    @star.status = :poyo
    assert_not @star.valid?

    @star.status = 'tekitou'
    assert_not @star.valid?
  end

  test 'must have a user' do
    @star.user = nil
    assert_not @star.valid?
  end

  test 'must have a date' do
    @star.date = nil
    assert_not @star.valid?
  end

  test 'Star#active?' do
    today = Date.new(1945, 6, 5)

    assert_not Star.active?(today), 'The day without any star is not active'

    star = @user.stars.create(date: today, status: :candidate)
    assert Star.active?(today), 'The day with a candidate star is active'

    star.update(status: :declined)
    assert Star.active?(today), 'The day with an accepted star is active'

    star.update(status: :accepted)
    assert Star.active?(today), 'The day with a declined star is active'
  end
end
