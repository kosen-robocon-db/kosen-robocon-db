module GameDetailsHelper
  def option_numbers(
    default_display: "--",
    default_value:   GameDetail::Constant::UNKNOWN_VALUE,
    begin_number:       0,
    end_number:        59,
    digit:              2,
    padding_string:   ' ',
    value_padding:  false,
    step:               1
  )
    numbers = Array([[default_display, default_value]])
    array_number = ( ( end_number - begin_number ) / step + 1 ).floor
    if value_padding then
      numbers.concat(Array.new(array_number) { |i|
        [
          ( i * step + begin_number ).to_s.rjust(digit, padding_string),
          ( i * step + begin_number ).to_s.rjust(digit, padding_string)
        ]
      })
    else
      numbers.concat(Array.new(array_number) { |i|
        [
          ( i * step + begin_number ).to_s.rjust(digit, padding_string),
            i * step + begin_number
        ]
      })
    end
  end

  def time_numbers
    option_numbers padding_string: '0', value_padding: true
  end
end
