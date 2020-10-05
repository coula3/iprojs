class Project < ActiveRecord::Base
    belongs_to :user
    validates :title, :start_date, :planned_end_date, presence: true
    validates_uniqueness_of :title, case_sensitive: false
    validates :title, format: { with: /\A[a-zA-Z0-9-:\s]+\z/, message: "only allows letters, numbers, spaces, colons and hyphens" }
    validates :url, format: { with: /\:\/+\w+\.[a-zA-Z]{2,}/, message: "must be valid" },
        if: Proc.new { |entry| entry.url.present? }

    validates_with ActualEndDateValidator
    validates_with ProjectDatesValidator

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods

    def format_dates(date_provided)
        date_provided.strftime("%b %d, %Y") if date_provided
    end
end
