class Professor < ApplicationRecord
    has_and_belongs_to_many :projects
  
    validates :pi_profile_id, presence: true, uniqueness: true
    validates :name, presence: true
    validates :university, presence: true
  
    def fetch_projects
      FetchProfessorProjectsJob.perform_later(self.id)
    end
  end