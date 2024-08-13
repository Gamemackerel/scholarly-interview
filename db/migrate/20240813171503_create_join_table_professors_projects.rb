class CreateJoinTableProfessorsProjects < ActiveRecord::Migration[7.0]
  def change
    create_join_table :professors, :projects do |t|
      t.index [:professor_id, :project_id]
      t.index [:project_id, :professor_id]
    end
  end
end