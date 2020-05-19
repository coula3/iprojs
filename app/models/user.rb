class User < ActiveRecord::Base
    has_many :projects
    has_secure_password

    validates :first_name, :last_name, :dob, presence: true
    validates :email, email: true
    validates_uniqueness_of :email
    validate :dob_must_be_at_least_ten_years_old

    def dob_must_be_at_least_ten_years_old
        if dob.present? && (Date.today.year - dob.year) < 10
            errors.add(:dob, "must be least 10 years")
        end
    end
end