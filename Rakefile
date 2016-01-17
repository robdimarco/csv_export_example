# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :benchmark do
  [1_000, 50_000, 500_000].each do |limit|
    Benchmark.bm do |x|
      x.report("#{limit} records with CSV library  :" ) { ExampleModel.limit(limit).to_csv }
      x.report("#{limit} records with PG COPY      :" ) { ExampleModel.limit(limit).to_csv_copy }
    end
  end
end
