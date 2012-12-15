namespace :archive do
  ARCHIVED_COUNT   = 100000
  CURRENT_COUNT    = 1000
  RUN_TIMES        = 1000

  task :create => :environment do

    date_values    = []
    bool_values    = []
    current_values = []
    now            = Time.now.utc

    ARCHIVED_COUNT.times do |i|
      date_values.push "('record-#{i}', '#{rand(400).days.ago}', '#{now}', '#{now}')"
      bool_values.push "('record-#{i}', true, '#{now}', '#{now}')"
    end

    CURRENT_COUNT.times do |i|
      date_values.push    "('record-#{ARCHIVED_COUNT+i}', null, '#{now}', '#{now}')"
      bool_values.push    "('record-#{ARCHIVED_COUNT+i}', false, '#{now}', '#{now}')"
      current_values.push "('record-#{ARCHIVED_COUNT+i}', '#{now}', '#{now}')"
    end

    CurrentWidget.delete_all
    DateWidget.delete_all
    BoolWidget.delete_all

    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute "INSERT INTO date_widgets    (name, archived_at, created_at, updated_at) VALUES #{date_values.join(', ')}"
      ActiveRecord::Base.connection.execute "INSERT INTO bool_widgets    (name, archived, created_at, updated_at)    VALUES #{bool_values.join(', ')}"
      ActiveRecord::Base.connection.execute "INSERT INTO current_widgets (name, created_at, updated_at)              VALUES #{current_values.join(', ')}"
    end
  end

  task :benchmark => :environment do
    def rand_current_name
      "record-#{ARCHIVED_COUNT+rand(CURRENT_COUNT)}"
    end

    def rand_archived_name
      "record-#{rand(ARCHIVED_COUNT)}"
    end

    puts "CurrentWidget:  #{CurrentWidget.count}"
    puts "DateWidget:     #{DateWidget.current.count}/#{DateWidget.count} current"
    puts "BoolWidget:     #{BoolWidget.current.count}/#{BoolWidget.count} current"

    Benchmark.bm do |x|
      puts '--- Current'
      x.report("Current") { RUN_TIMES.times { CurrentWidget.where(name: rand_current_name).first } }
      x.report("Date")    { RUN_TIMES.times { DateWidget.current.where(name: rand_current_name).first } }
      x.report("Bool")    { RUN_TIMES.times { BoolWidget.current.where(name: rand_current_name).first } }

      puts '--- Archived'
      x.report("Date") { RUN_TIMES.times { DateWidget.archived.where(name: rand_archived_name).first } }
      x.report("Bool") { RUN_TIMES.times { BoolWidget.archived.where(name: rand_archived_name).first } }
    end
  end

end
