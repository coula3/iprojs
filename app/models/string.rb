class String
    def titlecase
        string_arrray = self.split
        exclusions = %w(of and in from the to is for)

        capitalize_array = string_arrray.map do |str| 
            if exclusions.none?(str) && str.include?("-")
                new_array = str.gsub("-", " ").split
                new_array.map {|str| str.capitalize}.join(" ").gsub(" ", "-")
            elsif exclusions.include?(str)
                str
            else
                str.capitalize
            end
        end
        
        return_string_titlecase(capitalize_array)
    end

    def sanitize_name_roman_suffix
        if self.upcase.end_with?("VI", "VII", "VIII")
            self
        elsif self.upcase.end_with?("I")
            upcase_suffix(self)
        elsif self.upcase.end_with?("II")
            upcase_suffix(self)
        elsif self.upcase.end_with?("III")
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

    def return_string_titlecase(capitalize_array)
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
        else
            ""
        end
    end
end