class CreateProfessors < ActiveRecord::Migration[7.0]
  def change
    create_table :professors do |t|
      t.integer :pi_profile_id, null: false
      t.string :name
      t.string :university

      t.timestamps
    end

    add_index :professors, :pi_profile_id, unique: true
  end
end