if !Rails.env.production?
  puts 'Deleting database...'
  Lunch.delete_all
  Group.delete_all
  User.delete_all
  puts "Done deleting Database\n"


  puts "Starting to create data..."
  i = 1
  30.times do
    User.create(email: "#{i}@crowddesk.de")
    i += 1
  end

  User.all.each do |u|
    Lunch.create(user: u, date: Date.tomorrow)
  end

  Group.create_all_groups!
  puts "Done creating data\n"

  puts "#{User.count} users created who have"
  puts "#{Lunch.count} lunches in"
  puts "#{Group.count} groups\n"
else
  puts "Can't run in production"
end
