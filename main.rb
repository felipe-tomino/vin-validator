require_relative "vin"

vin_input = ARGV[0]
vin = VIN.new(vin_input)

puts "Provided VIN: #{vin.id}"
if vin.is_check_digit_valid()
  puts "Check Digit: VALID\nThis looks like a VALID vin!"
else
  puts "Check Digit: VALID || INVALID\nSuggested VIN(s):"
  suggested_vins = vin.suggested_vins()
end
