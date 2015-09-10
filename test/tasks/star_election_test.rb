require 'test_helper'

class StarElectionTest < ActiveSupport::TestCase

  def setup
    @taian_day = Date.new(2015, 9, 5)
  end

  test "rake stars:election should create stars on 大安" do
    stars_count = (User.count / 100.0).ceil

    travel_to(@taian_day) do
      assert_difference "Star.count", stars_count do
        Rake::Task['stars:election'].invoke
      end
    end
  end

  test "rake stars:election should not create stars except on 大安" do
    1.upto(5) do |i|
      travel_to(@taian_day+i) do
        assert_no_difference "Star.count" do
          Rake::Task['stars:election'].invoke
        end
      end
    end
  end
end

