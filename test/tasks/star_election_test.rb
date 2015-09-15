require 'test_helper'

class StarElectionTest < ActiveSupport::TestCase

  def setup
    @taian_day = Time.zone.local(2015, 9, 5).to_date
  end

  test "rake stars:elect_if_taian should create stars on 大安" do
    stars_count = (User.where(activated: true).count / 100.0).ceil

    travel_to(@taian_day) do
      assert_difference "Star.count", stars_count do
        Rake::Task['stars:elect_if_taian'].execute
      end
    end
  end

  test "rake stars:elect_if_taian should not create stars except on 大安" do
    1.upto(5) do |i|
      travel_to(@taian_day+i) do
        assert_no_difference "Star.count" do
          Rake::Task['stars:elect_if_taian'].execute
        end
      end
    end
  end

  test "rake stars:elect should always create stars" do
    stars_count = (User.where(activated: true).count / 100.0).ceil

    0.upto(5) do |i|
      travel_to(@taian_day+i) do
        assert_difference "Star.count", stars_count do
          Rake::Task['stars:elect'].execute
        end
      end
    end
  end
end

