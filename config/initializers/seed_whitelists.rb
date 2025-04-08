Rails.application.config.after_initialize do
     if ActiveRecord::Base.connection.table_exists?('whitelists')
          whitelists = [
               { email: "kwohjinyuan@tamu.edu", expires_at: nil, roles: "admin" },
               { email: "griffinbeaudreau@tamu.edu", expires_at: nil, roles: "admin" },
               { email: "nicholasmatias@tamu.edu", expires_at: nil, roles: "admin" },
               { email: "suresh06192004@tamu.edu", expires_at: nil, roles: "admin" },
               { email: "james.reyes@tamu.edu", expires_at: nil, roles: "admin" },
               { email: "sudhanvarajesh@tamu.edu", expires_at: nil, roles: "admin" },
               { email: "samraatg@tamu.edu", expires_at: nil, roles: "admin" }
          ]

          whitelists.each do |email|
               Whitelist.find_or_create_by!(email: email[:email]) do |w|
                    w.expires_at = email[:expires_at]
                    w.roles = email[:roles]
               end
          end

          puts "Whitelisted emails seeded successfully"
     end
end
