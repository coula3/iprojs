class User < ActiveRecord::Base
    has_many :projects
    has_secure_password

    validates :first_name, :last_name, :dob, presence: true
    validates :email, presence: true, email: true
    validates_uniqueness_of :email
end