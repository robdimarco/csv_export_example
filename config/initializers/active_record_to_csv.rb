module ActiveRecordCsvMethods
  def to_csv
    require 'csv'
    headers_needed = false
    CSV.generate do |csv|
      each do |row|
        if headers_needed
          csv << row.attributes.keys
          headers_needed = false
        end
        csv << row.attributes.values
      end
    end
  end

  def to_csv_copy
    rc = connection.raw_connection
    rv = []
    rc.copy_data("copy (#{to_sql}) to stdout with csv header") do
      # rubocop:disable AssignmentInCondition
      while line = rc.get_copy_data
        [] << line
      end
    end
    rv.join
  end
end

ActiveRecord::Relation.include(ActiveRecordCsvMethods)
