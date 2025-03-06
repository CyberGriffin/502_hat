Rails.application.config.after_initialize do
    if ActiveRecord::Base.connection.table_exists?('whitelisted_emails')
      whitelists = [
        { email: "kwohjinyuan@tamu.edu", expires_at: nil },
        { email: "griffinbeaudreau@tamu.edu", expires_at: nil },
        { email: "nicholasmatias@tamu.edu", expires_at: nil },
        { email: "suresh06192004@tamu.edu", expires_at: nil },
        { email: "james.reyes@tamu.edu", expires_at: nil },
      ]
  
      emails.each do |email|
        WhitelistedEmail.find_or_create_by!(email: email)
      end
  
      puts "Whitelisted emails seeded successfully"
    end
  end
  