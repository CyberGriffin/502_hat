Rails.application.config.after_initialize do
  if ActiveRecord::Base.connection.table_exists?('departments')  
    departments = [
    { dept_id: "AERO", name: "Aerospace Engineering" },
    { dept_id: "BAEN", name: "Biological and Agricultural Engineering" },
    { dept_id: "BMEN", name: "Biomedical Engineering" },
    { dept_id: "CHEN", name: "Chemical Engineering" },
    { dept_id: "CVEN", name: "Civil and Environmental Engineering" },
    { dept_id: "CSCE", name: "Computer Science and Engineering" },
    { dept_id: "ECEN", name: "Electrical and Computer Engineering" },
    { dept_id: "ENTC", name: "Engineering Technology and Industrial Distribution" },
    { dept_id: "ISEN", name: "Industrial and Systems Engineering" },
    { dept_id: "MSEN", name: "Materials Science and Engineering" },
    { dept_id: "MEEN", name: "Mechanical Engineering" },
    { dept_id: "MXET", name: "Multidisciplinary Engineering" },
    { dept_id: "NUEN", name: "Nuclear Engineering" },
    { dept_id: "OCEN", name: "Ocean Engineering" },
    { dept_id: "PETE", name: "Petroleum Engineering" },
    { dept_id: "-", name: "Not Selected" },
  ]

  departments.each do |dept|
    Department.find_or_create_by!(dept_id: dept[:dept_id]) do |d|
      d.name = dept[:name]
    end
  end
  puts "Departments seeded successfully"
end
end 