# app/jobs/fetch_professor_projects_job.rb
class FetchProfessorProjectsJob < ApplicationJob
  queue_as :default

  def perform(professor_id)
    professor = Professor.find(professor_id)
    service = NihReporterService.new
    offset = 0
    limit = 100

    loop do
      projects = service.fetch_projects(professor.pi_profile_id, offset, limit)
      break if projects.empty?

      projects.each do |project_data|
        project = Project.find_or_initialize_by(appl_id: project_data['appl_id'])
        project.assign_attributes(
          subproject_id: project_data['subproject_id'],
          fiscal_year: project_data['fiscal_year'],
          organization: project_data['organization']['org_name'],
          project_num: project_data['project_num'],
          org_country: project_data['organization']['org_country'],
          project_num_split: project_data['project_num_split']['full_support_year'],
          contact_pi_name: project_data['contact_pi_name'],
          all_text: project_data['full_study_section']['name'],
          full_study_section: project_data['full_study_section']['name'],
          project_start_date: project_data['project_start_date'],
          project_end_date: project_data['project_end_date']
        )
        project.save!
        professor.projects << project unless professor.projects.include?(project)
      end

      offset += limit
    end
  end
end