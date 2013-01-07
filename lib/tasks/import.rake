namespace :import do
  desc "Import data in the database"

  task :accidents => :environment do
    require 'csv'
    csv_text = File.read(Rails.root.join('db', 'data', 'accidents.csv'))
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      row = row.to_hash.with_indifferent_access
      Accident.create!(row.to_hash.symbolize_keys)
    end
  end

  task :details => :environment do
    require 'csv'
    csv_text = File.read(Rails.root.join('db', 'data', 'detail.csv'))
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      row = row.to_hash.with_indifferent_access
      if Accident.exists?(:numac => row[:numac])
        Detail.create!( :hospitalises => row[:hospitalises],
                        :indemnes => row[:indemnes],
                        :legers => row[:legers],
                        :misecirc => row[:misecirc],
                        :numac => row[:numac],
                        :tues => row[:tues],
                        :vehicule => get_categrie_vehicule(row[:vehicule]))


      end

    end
  end

  task :reimport => :environment do
    puts "Reloading the database..."
    Rake::Task["db:schema:load"].invoke
    puts ""
    puts "Import accident data..."
    Rake::Task["import:accidents"].invoke
    puts ""
    puts "Import accident details data..."
    Rake::Task["import:details"].invoke
    puts ""
    puts "Reimport done."
  end
end

def get_categrie_vehicule(cat)
  if cat == '01'
    return 1 # velos
  elsif ['02', '04', '05', '06', '30', '31', '32', '33', '34'].include? cat
    return 2 # deux roues motorises
  elsif ['07', '08', '09', '10', '11', '12'].include? cat
    return 3 # vehicules legers
  elsif ['03', '20', '21', '35', '36'].include? cat
    return 4 # autres
  elsif ['13', '14', '15', '16', '17'].include? cat
    return 5 # poids lourds
  elsif ['18', '19', '37', '38', '39', '40', '99'].include? cat
    return 6 # transports en commun
  else
    puts "Unknown categorie " + cat
    return 0
  end
end