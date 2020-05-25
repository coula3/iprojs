require_relative 'concerns/slugifiable.rb'

class Project < ActiveRecord::Base
    belongs_to :user
    validates :title, presence: true
    validates :url, format: { with: /\:\/+\w+\.[a-zA-Z]{2,}/, message: "must be valid" },
        if: Proc.new { |entry| entry.url.present? }

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
end
