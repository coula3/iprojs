class User < ActiveRecord::Base
    has_many :projects
    has_secure_password

    validates :first_name, :last_name, :dob, :email, presence: true
    validates_uniqueness_of :email
end
