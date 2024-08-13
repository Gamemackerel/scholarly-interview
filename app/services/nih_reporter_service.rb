# app/services/nih_reporter_service.rb
require 'net/http'
require 'json'

class NihReporterService
  BASE_URL = 'https://api.reporter.nih.gov/v2'

  def fetch_projects(pi_profile_id, offset = 0, limit = 10)
    uri = URI("#{BASE_URL}/projects/search")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/json'

    body = {
      searchId: "search_#{pi_profile_id}",
      criteria: {
        pi_profile_ids: [pi_profile_id]
      },
      include_fields: [
        "ApplId", "SubprojectId", "FiscalYear", "Organization", "ProjectNum", "OrgCountry",
        "ProjectNumSplit", "ContactPiName", "AllText", "FullStudySection",
        "ProjectStartDate", "ProjectEndDate"
      ],
      offset: offset,
      limit: limit
    }

    request.body = JSON.generate(body)

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)['results']
    else
      Rails.logger.error "Error fetching projects: #{response.code} - #{response.body}"
      []
    end
  rescue StandardError => e
    Rails.logger.error "Error in NihReporterService: #{e.message}"
    []
  end
end