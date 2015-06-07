require 'rest-client'
require 'keychain'
require 'base64'
require 'byebug'

module OmniFocus::Extrabrain
  PREFIX = 'EB'

  class Task
    attr_accessor :id, :title, :project_id, :team
    attr_writer :project_title

    def initialize(attrs = {})
      attrs.each do |attribute, value|
        setter = "#{attribute}="
        if respond_to? setter
          public_send setter, value
        end
      end
    end

    def url
      "https://#{team['subdomain']}.extrabrain.se/tasks/#{id}"
    end

    def ticket_id
      "#{PREFIX}##{id}"
    end

    def project_title
      if @project_title.to_s.gsub(' ', '') == ''
        'Miscellaneous'
      else
        @project_title
      end
    end
  end

  def keychain_user
    params = { server: 'extrabrain.se', protocol: Keychain::Protocols::HTTPS }
    Keychain.internet_passwords.where(params).first
  end

  def username
    @username ||= keychain_user.account
  end

  def password
    @password ||= keychain_user.password
  end

  # This is the method `of sync` calls.
  def populate_extrabrain_tasks
    teams.each do |team|
      page = 1
      while tasks = get_tasks(team, page) do
        tasks.each { |task| process_extrabrain_task(task, team) }
        page = page + 1
      end
    end
  end

  def client(url)
    headers = {
        :accept => :json,
        :content_type => :json,
    }
    RestClient::Resource.new(url, :headers => headers, user: username, password: password)
  end

  def teams
    JSON.parse resource['teams.json'].get
  end

  def user_id
    @user_id ||= begin
      current_user = JSON.parse resource['users/current.json'].get
      current_user['user']['id']
    end
  end

  def resource
    @resource ||= client('https://extrabrain.se')
  end

  def get_tasks(team, page)
    team_resource = client("https://#{team['subdomain']}.extrabrain.se")
    json = JSON.parse team_resource["tasks.json?user_id=#{user_id}&page=#{page}"].get
    return nil if json.nil? || json.empty?
    json.map { |task_attributes| Task.new(task_attributes.merge team: team) }
  end

  def process_extrabrain_task(task, team)
    if existing[task.ticket_id]
      bug_db[existing[task.ticket_id]][task.ticket_id] = true
    else
      title = "#{task.ticket_id}: #{task.title}"
      description = task.url
      bug_db[task.project_title][task.ticket_id] = [title, description]
    end
  end
end
