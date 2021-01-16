class VIN
  @@CHECK_DIGITS = ['0','1','2','3','4','5','6','7','9','10','X']
  @@WEIGHTS = [8,7,6,5,4,3,2,10,0,9,8,7,6,5,4,3,2]
  @@VALID_CHARS = '0123456789ABCDEFGHJKLMNPRSTUVWXYZ'
  @@transliterate_chars = '0123456789.ABCDEFGH..JKLMN.P.R..STUVWXYZ'

  attr_reader :id

  def initialize(id)
    @id = id.upcase
    @check_digit = id[8]
    @sum = 0
  end

  def is_valid
    self.is_check_digit_valid() && self.is_all_char_valid()
  end

  def  is_check_digit_valid
    @check_digit == self.calculate_check_digit()
  end

  def is_all_char_valid
    @id.split('').all? { |char| @@VALID_CHARS.include? char }
  end

  def calculate_check_digit
    unless @calculated_check_digit
      @calculated_check_digit = @@CHECK_DIGITS[self.sum() % 11]
    end
    @calculated_check_digit
  end

  def sum
    unless @sum > 0
      @id.split('').each_with_index do |char, i|
        if @@VALID_CHARS.include? char
          @sum += self.transliterate(char) * @@WEIGHTS[i]
        end
      end
    end
    @sum
  end

  def suggested_vins
    suggested_vins = []

    replace_IOQ = @id.gsub('I', '1').gsub(/O|Q/, '0')
    if @id != replace_IOQ
      base_vin = VIN.new(replace_IOQ)
      suggested_vins.append(replace_IOQ) if base_vin.is_valid()
    else
      base_vin = self
    end
    # 2XPBDP9X8FD257820
    if base_vin.is_all_char_valid()
      base_vin.id.split('').each_with_index do |char, i|
        if i != 8
          (0..9).each do |possible_char_idx|
            new_sum = base_vin.sum() + (possible_char_idx - transliterate(char)) * @@WEIGHTS[i]
            if @@CHECK_DIGITS[new_sum % 11] == base_vin.id[8]
              self.get_possible_chars_from_value(possible_char_idx).each do |c|
                new_vin = base_vin.id[0, i] + c + base_vin.id[i + 1, 17]
                puts "#{base_vin.sum()} // #{new_vin}"
                suggested_vins.append(new_vin)
              end
            end
          end
        else
          new_vin = base_vin.id[0, 9] + base_vin.calculate_check_digit() + base_vin.id[10, 17]
          suggested_vins.append(new_vin)
        end
      end
    end
    suggested_vins
  end

  private
  def transliterate(char)
    @@transliterate_chars.split('').index(char) % 10
  end

  def get_possible_chars_from_value(value)
    (0..3).map { |i| @@transliterate_chars[i] }.filter { |c| c != '.' }
  end
end
