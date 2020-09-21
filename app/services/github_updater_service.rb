require 'open-uri'
class GithubUpdaterService

  def initialize(user)
    @user = user
    @client = Octokit::Client.new(access_token: user.token)
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
    # puts "New file will be created"
    begin
      file = @client.contents(@repo_id, path: "scripts/#{random_name}")
      # puts "Name already existed."
      return file
    rescue
      file = @client.create_contents(@repo_id, "scripts/#{random_name}", "Adding some content", "def this; end")
      # puts "New file was created."
      return file
    end
  end

  def get_random_file
    # binding.pry
    @client.contents(@repo_id, path: "scripts").sample
  end

  def update_file(file)
    begin
    @client.update_contents(@repo_id,
                     file.content&.path || file.path,
                     "Updating content",
                     file.content&.sha || file.sha,
                     Faker::TvShows::TwinPeaks.quote, branch: "master")
    # puts "File was updated"
    rescue
      # puts "This file update failed."
    end
  end

end
