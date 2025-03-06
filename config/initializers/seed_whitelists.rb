Rails.application.config.after_initialize do
    if ActiveRecord::Base.connection.table_exists?('whitelisted_emails')
      emails = [
        "kwohjinyuan@tamu.edu",
        "griffinbeaudreau@tamu.edu",
        "nicholasmatias@tamu.edu",
        "suresh06192004@tamu.edu",
        "james.reyes@tamu.edu"
      ]
  
      emails.each do |email|
        WhitelistedEmail.find_or_create_by!(email: email)
      end
  
      puts "Whitelisted emails seeded successfully"
    end
  end
  