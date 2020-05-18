require_relative 'concerns/slugifiable.rb'

class Project < ActiveRecord::Base
    belongs_to :user
    validates :title, presence: true

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
end
