# lib/tasks/seed_professors.rake
namespace :db do
    desc "Seed professors data"
    task seed_professors: :environment do
      professors_data = [
        { name: "John C. Fortney", university: "University of Washington", pi_profile_id: 1882630 },
        { name: "Sandra Juul", university: "University of Washington", pi_profile_id: 1918796 },
        { name: "Laurie Christine Eldredge", university: "University of Washington", pi_profile_id: 6931134 }
      ]
  
      professors_data.each do |prof_data|
        professor = Professor.find_or_initialize_by(pi_profile_id: prof_data[:pi_profile_id])
        professor.assign_attributes(prof_data)
        if professor.save
          puts "Professor #{professor.name} created or updated successfully."
        else
          puts "Error saving professor #{professor.name}: #{professor.errors.full_messages.join(', ')}"
        end
      end
  
      puts "Professors seeding completed!"
    end
  end