class String
    def titlecase
        string_arrray = self.split
        exclusions = %w(of and in from the to is)
        capitalize_array = string_arrray.map do |str| 
            if exclusions.none?(str) && str.include?("-")
                arr = str.gsub("-", " ").split
                arr.map {|a| a.capitalize}.join(" ").gsub(" ", "-")
            elsif exclusions.include?(str)
                str
            else
                str.capitalize
            end
        end
        
        if !capitalize_array.empty?
            first_str = capitalize_array.shift 
            if first_str.include?("-") && capitalize_array.count == 0
                capitalize_array.unshift(first_str)
            elsif first_str.include?("-") && capitalize_array.count > 0
                capitalize_array.unshift(first_str)
            elsif first_str == first_str.downcase
                capitalize_array.unshift(first_str.capitalize)
            else
                capitalize_array.unshift(first_str.capitalize)
            end.join(" ")
        end
    end

    def sanitize_name_roman_suffix
        if self.upcase.end_with?("I")
            upcase_suffix(self)
        elsif self.upcase.end_with?("II")
            upcase_suffix(self)
        elsif self.upcase.end_with?("III")
            upcase_suffix(self)
        elsif self.upcase.end_with?("IV")
            upcase_suffix(self)
        elsif self.upcase.end_with?("V")
            upcase_suffix(self)
        else
            self
        end
    end

    private

    def upcase_suffix(name_with_suffix)
        name_array = name_with_suffix.split(" ")
        upcased_suffix = name_array[-1].upcase
        name_array[-1] = upcased_suffix
        name_array.join(" ")
    end
end