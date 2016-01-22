namespace :site do
  desc 'import site and options from config'
  task import: :environment do
    Dir.glob "#{Rails.root}/config/scrapers/*.yml" do |file|
    end
  end
end
