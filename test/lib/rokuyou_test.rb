require 'test_helper'

class RokuyouTest < ActiveSupport::TestCase
  ROKUYOU = %i(taian? shakko? sensho? tomobiki? senpu? butsumetsu?)

  def setup
    @today = Date.new(2015, 9, 5)  # この日は大安
  end

  test "all in one" do
    0.upto(5) do |i|
      0.upto(5) do |j|
        if i == j
          assert     Rokuyou.new(@today+i).send(ROKUYOU[j])
        else
          assert_not Rokuyou.new(@today+i).send(ROKUYOU[j])
        end
      end
    end
  end
end
