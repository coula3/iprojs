class Integer
  def figures_hash
    figures ||= {
      0 => "zero", 
      1 => "one", 
      2 => "two", 
      3 => "three", 
      4 => "four", 
      5 => "five", 
      6 => "six", 
      7 => "seven", 
      8 => "eight", 
      9 => "nine", 
      10 => "ten",
      11 => "eleven",
      12 => "twelve",
      13 => "thirteen",
      14 => "fourteen",
      15 => "fifteen",
      16 => "sixteen",
      17 => "seventeen",
      18 => "eighteen",
      19 => "nineteen",
      20 => "twenty",
      30 => "thirty",
      40 => "forty",
      50 => "fifty",
      60 => "sixty",
      70 => "seventy",
      80 => "eighty",
      90 => "ninety",
      100 => "hundred",
      1000 => "thousand",
      1000000 => "million"
    }
  end
  
  def to_words
    if self <= 20
      figures_hash[self]
    elsif self > 20 && self < 100
      twenty_to_ninety_nine(self)
    end
  end

  private
  def twenty_to_ninety_nine(figure)
    tens = figure / 10 * 10
    ones = (tens - figure) * -1
    "#{figures_hash[tens]} #{figures_hash[ones]}"
  end
end

p 43.to_words
