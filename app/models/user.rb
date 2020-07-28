class User < ActiveRecord::Base
    has_many :projects
    
    validates :first_name, :last_name, :date_of_birth, presence: true
    validates :email, email: true
    validates_uniqueness_of :email, case_sensitive: false
    validate :dob_must_be_at_least_ten_years_old
    has_secure_password
    validates :password, confirmation: true
    validates :password_confirmation, presence: true

    def dob_must_be_at_least_ten_years_old
        if (date_of_birth.present? && date_of_birth <= Date.today) && calculate_age < 10
            errors.add(:date_of_birth, "must be least 10 years")
        end
    end

    def calculate_age
        Date.today < self.date_of_birth + (Date.today.year - self.date_of_birth.year).years ?  Date.today.year - self.date_of_birth.year - 1 : Date.today.year - self.date_of_birth.year
    end
end 