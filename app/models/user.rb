class User < ActiveRecord::Base
    has_many :projects
    has_secure_password

    validates :first_name, :last_name, :dob, :email, presence: true
    validates :password, length: { in: 3..6 }
    validates_uniqueness_of :email
end
