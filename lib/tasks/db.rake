namespace :db do
  desc "Run migrations (rake [environment=development] db:migrate)"
  task :migrate do |t, args|
    environment = ENV["environment"] || "development"
    require "sequel"
    Sequel.extension :migration
    tbconfig = YAML.load_file('config/torquebox.yml')
    db = Sequel.connect(tbconfig['environment']["#{environment}"]['data_source'])
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrations")
    end
    #system "sequel -m db/migrations #{tbconfig['environment']['data_source']}"
  end
  
  desc "Rollback migrations one version (rake [environment=development] db:rollback)"
  task :rollback do
    environment = ENV["environment"] || "development"
    require "sequel"
    Sequel.extension :migration
    tbconfig = YAML.load_file('config/torquebox.yml')
    db = Sequel.connect(tbconfig['environment']["#{environment}"]['data_source'])
    row = db["SELECT version FROM schema_info"].first
    version = row[:version] - 1
    
    version = 0 if version < 0
    puts version
    Sequel::Migrator.run(db, "db/migrations", target: version)
  end

end
