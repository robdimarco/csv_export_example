# CSV Export Example

## Problem to Solve
- Wanted to speed up an export to CSV
- Use [PostgreSQL COPY](http://www.postgresql.org/docs/current/static/sql-copy.html) function to improve performance

# How It Works

1. Create a view in PostgreSQL with 1,000,000 rows
2. Create a `ActiveRecord` object named `ExampleModel` backed by this view
3. Extended `ActiveRecord::Relation` with two methods `to_csv` and `to_csv_copy`. `to_csv` uses Ruby's built in [CSV](http://ruby-doc.org/stdlib-2.2.4/libdoc/csv/rdoc/CSV.html) while `to_csv_copy` uses the PostgreSQL COPY command.

## Using PostgreSQL COPY

To use the PostgreSQL COPY command we need to do a few things:

1. Get access to the raw [`pg`](https://bitbucket.org/ged/ruby-pg/wiki/Home) connection with `connection.raw_connection`
2. Execute the COPY command. We do this by using the `to_sql` method of `ActiveRecord::Relation` to get the base SQL we want to execute and then running the copy, printing to `stdout`.
3. We then call the [`get_copy_data`](http://www.rubydoc.info/gems/pg/PG%2FConnection%3Aget_copy_data) to get the copy data in CSV form.


# What We See

For small number of records (~1,000), there is no noticeable difference in performance between the `to_csv` and the `to_csv_copy`.
But as the amount of data increases, you can start to see gigantic performance improvements.

On my development machine, I see speed ups of ~9x for 50,000 rows and 30x for 500,000 rows.

# To Run The Benchmark

    $ bundle install
    $ rake db:migrate
    $ rake benchmark
