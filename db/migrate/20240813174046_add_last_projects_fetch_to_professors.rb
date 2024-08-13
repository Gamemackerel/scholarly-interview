# db/migrate/[timestamp]_add_last_projects_fetch_to_professors.rb
class AddLastProjectsFetchToProfessors < ActiveRecord::Migration[7.0]
  def change
    add_column :professors, :last_projects_fetch, :datetime
  end
end