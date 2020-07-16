desc "This task is called by the Heroku scheduler add-on"
task :create_groups => :environment do
  puts "Creating groups..."
  Group.create_all_groups!
  puts "done."
end
