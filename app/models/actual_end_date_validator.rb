class ActualEndDateValidator < ActiveModel::Validator
    def validate(record)
        if (record.phase == "Completed" || record.phase == "Production") && record.actual_end_date.nil?
            record.errors[:base] << "Projects at 'Completed' or 'Production' phases are required to have actual end dates"
        end
    end
end