class CreateExampleModels < ActiveRecord::Migration
  def up
    execute <<-SQL
    CREATE VIEW example_models AS
    select generate_series id, round(random() * 100) sales_count from generate_series(1, 1000000);
    SQL
  end

  def down
    execute <<-SQL
    DROP VIEW example_models
    SQL
  end
end
