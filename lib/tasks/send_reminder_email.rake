task :send_reminder => :environment do
  UserMailer.reminder_mail.deliver
end
