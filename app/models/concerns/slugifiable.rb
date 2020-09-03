module Slugifiable
    module InstanceMethods
        def slug
            if self.has_attribute?("title")
                self.title.gsub(" ", "-").downcase
            elsif self.respond_to?(:full_name)
                self.full_name.gsub(" ", "-").downcase
            end
        end
    end

    module ClassMethods
        def find_by_slug(slug)
            self.all.find {|instance| instance.slug == slug}
        end
    end
end