# CSV Export Example

## Problem to Solve
- Wanted to speed up an export to CSV
- Use [PostgreSQL COPY](http://www.postgresql.org/docs/current/static/sql-copy.html) function to improve performance

## How It Works

1. [Create a view in PostgreSQL with 1,000,000 rows](https://github.com/robdimarco/csv_export_example/blob/master/db/migrate/20160117015839_create_example_models.rb)
2. Create a [`ActiveRecord` object named `ExampleModel`](https://github.com/robdimarco/csv_export_example/blob/master/app/models/example_model.rb) backed by this view
3. [Extend `ActiveRecord::Relation` with two methods `to_csv` and `to_csv_copy`](https://github.com/robdimarco/csv_export_example/blob/master/config/initializers/active_record_to_csv.rb). `to_csv` uses Ruby's built in [CSV](http://ruby-doc.org/stdlib-2.2.4/libdoc/csv/rdoc/CSV.html) while `to_csv_copy` uses the PostgreSQL COPY command.

## Using PostgreSQL COPY

To use the PostgreSQL COPY command we need to do a few things:

1. Get access to the raw [`pg`](https://bitbucket.org/ged/ruby-pg/wiki/Home) connection with `connection.raw_connection`
2. Execute the COPY command. We do this by using the `to_sql` method of `ActiveRecord::Relation` to get the base SQL we want to execute and then running the copy, printing to `stdout`.
3. We then call the [`get_copy_data`](http://www.rubydoc.info/gems/pg/PG%2FConnection%3Aget_copy_data) to get the copy data in CSV form.


## What We See

For small number of records (~1,000), there is no noticeable difference in performance between the `to_csv` and the `to_csv_copy`.
But as the amount of data increases, you can start to see gigantic performance improvements.

On my development machine, I see speed ups of ~9x for 50,000 rows and 30x for 500,000 rows.

## To Run The Benchmark

    $ bundle install
    $ rake db:migrate
    $ rake benchmark

### Example Results

           user     system      total        real
    1000 records with CSV library  :  0.090000   0.010000   0.100000 (  0.450539)
    1000 records with PG COPY      :  0.000000   0.000000   0.000000 (  0.327618)
           user     system      total        real
    50000 records with CSV library  :  2.650000   0.100000   2.750000 (  3.157916)
    50000 records with PG COPY      :  0.040000   0.020000   0.060000 (  0.431258)
           user     system      total        real
    500000 records with CSV library  : 29.190000   0.820000  30.010000 ( 31.398112)
    500000 records with PG COPY      :  0.460000   0.180000   0.640000 (  1.308529)

