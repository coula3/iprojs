class User < ActiveRecord::Base
    has_many :projects
    
    validates :first_name, :last_name, :date_of_birth, :email, presence: true
    validates :first_name, :last_name, format: { with: /\A[a-zA-Z\-\s]+\z/, message: "only allows letters, space and hyphen" }, :if => lambda{first_name.present? && last_name.present?}
    validates :email, email: true
    validates_uniqueness_of :email, case_sensitive: false
    validate :dob_must_be_at_least_thirteen_years_old
    has_secure_password

    validates :password, confirmation: true, :if => lambda{ new_record? && password.present? }

    def dob_must_be_at_least_thirteen_years_old
        if date_of_birth.present? && calculate_age < 13
            errors.add(:date_of_birth, "must be least 13 years")
        end
    end

    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods

    def calculate_age
        Date.today < self.date_of_birth + (Date.today.year - self.date_of_birth.year).years ?  Date.today.year - self.date_of_birth.year - 1 : Date.today.year - self.date_of_birth.year
    end

    def full_name
        self.first_name + " " + self.last_name
    end
end 