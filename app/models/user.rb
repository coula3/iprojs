class User < ActiveRecord::Base
    has_many :projects
    
    validates :first_name, :last_name, :date_of_birth, presence: true
    validates :email, email: true
    validates_uniqueness_of :email
    validate :dob_must_be_at_least_ten_years_old
    has_secure_password

    def dob_must_be_at_least_ten_years_old
            if date_of_birth.present? && (Date.today.year - date_of_birth.year) < 10
            errors.add(:date_of_birth, "must be least 10 years")
        end
    end
end