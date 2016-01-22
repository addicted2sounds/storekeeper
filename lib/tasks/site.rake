namespace :site do
  desc 'import site and options from config'
  task import: :environment do
    Dir.glob "#{Rails.root}/config/scrapers/*.yml" do |file|
      specs = YAML.load_file(file).with_indifferent_access
      site = Site.find_or_create_by(url: specs[:url])
      site.name = specs[:name]
      site.save!
      specs[:options].each do |name, opts|
        option = ProductOption.find_or_create_by(site: site, name: name)
        option.update_attributes! opts
      end
    end
  end
end
