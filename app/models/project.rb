require_relative 'concerns/slugifiable.rb'

class Project < ActiveRecord::Base
    belongs_to :user
    validates :title, presence: true
    validates_uniqueness_of :title, case_sensitive: false
    validates :url, format: { with: /\:\/+\w+\.[a-zA-Z]{2,}/, message: "must be valid" },
        if: Proc.new { |entry| entry.url.present? }

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods

    def format_dates(date_provided)
        date_provided.strftime("%b %d, %Y") if date_provided
    end
end
