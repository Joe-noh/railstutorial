require 'test_helper'

class StarElectionTest < ActiveSupport::TestCase

  def setup
    @taian_day = Time.zone.local(2015, 9, 5).to_date
  end

  test "rake stars:election should create stars on 大安" do
    stars_count = (User.where(activated: true).count / 100.0).ceil

    travel_to(@taian_day) do
      assert_difference "Star.count", stars_count do
        Rake::Task['stars:election'].execute
      end
    end
  end

  test "rake stars:election should not create stars except on 大安" do
    1.upto(5) do |i|
      travel_to(@taian_day+i) do
        assert_no_difference "Star.count" do
          Rake::Task['stars:election'].execute
        end
      end
    end
  end
end

