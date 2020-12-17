require 'open-uri'
class GithubUpdaterService

  def initialize(user)
    @user = user
    @client = Octokit::Client.new(access_token: user.token)
    @should_commit = consider_weekends
  end

  def create_repos(options = {})
    number = options[:amount] || 1
    number.times do |n|
      response = @client.create_repository "HubGitterRepo-#{n}", private: true, description: "This is an auto-commiting private repository made with HubGitter"
      UserRepo.create!(user: @user, repo_id: response[:id])
      create_scripts_folder(response[:id].to_i)
    end
  end

  def delete_all_repos
    @user.user_repos.each do |repo|
      @client.delete_repository(repo.repo_id.to_i)
    end
    @user.user_repos.destroy_all
  end

  def commit
    return unless should_commit

    @repo_id = @user.user_repos.sample.repo_id.to_i

    if create_new_file?
      file = create_random_file
    else
      file = get_random_file
    end

    update_file(file)

  end

  private

  def create_scripts_folder(repo_id)
    @client.create_contents(repo_id, "scripts/scraper.rb", "Adding some content", "def this; end")
  end

  def create_new_file?
    case rand(100)
      when  94..99 then return true
    end
    return false
  end

  def create_random_file
    names_url = "https://gist.githubusercontent.com/Caloma11/5c7f1873f60930fb52eb7e9366160768/raw/580ec969180ef4ecf0a8b29026b7d8c013cfef44/names.json"
    names_hash = JSON.parse(open(names_url).read)
    random_name = names_hash["names"].sample
    puts "New file will be created"
    begin
      file = @client.contents(@repo_id, path: "scripts/#{random_name}")
      puts "Name already existed."
      return file
    rescue
      file = @client.create_contents(@repo_id, "scripts/#{random_name}", "Adding some content", "def this; end")
      puts "New file was created."
      return file
    end
  end

  def get_random_file
    @client.contents(@repo_id, path: "scripts").sample
  end

  def update_file(file)
    begin
    @client.update_contents(@repo_id,
                     file.content&.path || file.path,
                     "Updating content",
                     file.content&.sha || file.sha,
                     random_code, branch: "master")
    puts "File was updated"
    rescue
      puts "This file update failed."
    end
  end

  def random_code
    index_url = "https://stackoverflow.com/questions/tagged/ruby?tab=votes&page=#{rand(40)}&pagesize=50"

    questions_html_file = open(index_url).read
    questions_html_doc = Nokogiri::HTML(questions_html_file)

    questions_urls = []

    questions_html_doc.search('.question-hyperlink').each do |element|
      href = element.attribute('href').value
      if href.match?(/^\/questions/)
        questions_urls << "https://stackoverflow.com#{href}"
      end
    end

    code = []

    questions_urls.sample(2).each do |question_url|
      question_html_file = open(question_url).read
      question_html_doc = Nokogiri::HTML(question_html_file)
      code << question_html_doc.search('#answers code').first.text
    end

    return code.join("\n")
  end

  def consider_weekends
    if Date.today.sunday?
      (rand(1..10) > 8)
    elsif Date.today.saturday?
      (rand(1..10) > 6)
    else
      true
    end
  end

end
