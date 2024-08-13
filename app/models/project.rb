class Project < ApplicationRecord
    has_and_belongs_to_many :professors
  
    validates :appl_id, presence: true
    validates :project_num, presence: true
    validates :fiscal_year, presence: true
  end