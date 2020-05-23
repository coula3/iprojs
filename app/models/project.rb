require_relative 'concerns/slugifiable.rb'

class Project < ActiveRecord::Base
    belongs_to :user
    validates :title, :url, presence: true
    validates :url, format: { with: /\:\/+\w+\.[a-z]{2,}/, message: "must be valid" }

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
end
