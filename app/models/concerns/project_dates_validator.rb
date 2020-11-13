class ProjectDatesValidator < ActiveModel::Validator
    def validate(record)
        if record.actual_end_date && record.actual_end_date > Time.now
            record.errors[:base] << "Actual End Date must not be a future date"
        elsif record.planned_end_date && (record.planned_end_date < record.start_date)
            record.errors[:base] << "Planned End Date must not be earlier than Start Date"
        elsif record.actual_end_date && (record.actual_end_date < record.start_date)
            record.errors[:base] << "Actual End Date must not be earlier than Start Date"
        end
    end
end