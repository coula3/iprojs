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