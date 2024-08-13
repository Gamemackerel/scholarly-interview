class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :appl_id
      t.string :subproject_id
      t.integer :fiscal_year
      t.string :organization
      t.string :project_num
      t.string :org_country
      t.string :project_num_split
      t.string :contact_pi_name
      t.text :all_text
      t.string :full_study_section
      t.date :project_start_date
      t.date :project_end_date

      t.timestamps
    end

    add_index :projects, :appl_id
    add_index :projects, :project_num
  end
end