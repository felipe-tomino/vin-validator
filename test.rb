require_relative "vin"
require "test/unit"
 
class TestVIN < Test::Unit::TestCase
  def test_valid_vin()
    vin_id = '1NKDLU0X33R385016'
    vin = VIN.new(vin_id)

    assert_equal('3', vin.calculate_check_digit())
    assert_equal(377, vin.sum())
    assert_true(vin.is_valid())
  end

  def test_invalid_char_vin()
    vin_id = 'INKDLUOX33R385Q16'
    vin = VIN.new(vin_id)

    assert_false(vin.is_valid())
    assert_includes(vin.suggested_vins(), '1NKDLU0X33R385016')
  end

  def test_invalid_check_digit_vin()
    vin_id = '1XPBDP9X1FD257820'
    vin = VIN.new(vin_id)

    assert_false(vin.is_valid())
    assert_includes(vin.suggested_vins(), '1XPBDP9X8FD257820')
  end

  def test_other_invalid_digit_vin()
    vin_id = '2XPBDP9X8FD257820'
    vin = VIN.new(vin_id)

    assert_false(vin.is_valid())
    suggested_vins = vin.suggested_vins()
    ['1', 'A', 'J'].each { |c| assert_includes(suggested_vins, c + 'XPBDP9X8FD257820') }
  end
end
