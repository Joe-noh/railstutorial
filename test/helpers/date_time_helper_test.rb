require 'test_helper'

class DateTimeHelperTest < ActionView::TestCase
  test 'shifted date' do
    assert_equal Date.new(2016, 1, 15), shifted_date(Time.zone.local(2016, 1, 15, 10))
    assert_equal Date.new(2016, 1, 15), shifted_date(Time.zone.local(2016, 1, 15, 12))
    assert_equal Date.new(2016, 1, 15), shifted_date(Time.zone.local(2016, 1, 16, 2, 59, 59))
    assert_equal Date.new(2016, 1, 16), shifted_date(Time.zone.local(2016, 1, 16, 3))
    assert_equal Date.new(2016, 1, 16), shifted_date(Time.zone.local(2016, 1, 16, 5))
  end

  test 'shifted date from utc' do
    # date changes at 18:00 UTC (== 27:00 JST)
    assert_equal Date.new(2016, 1, 15), shifted_date(Time.utc(2016, 1, 15, 17))
    assert_equal Date.new(2016, 1, 16), shifted_date(Time.utc(2016, 1, 15, 18))
  end
end
