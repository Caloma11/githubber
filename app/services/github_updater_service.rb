class GithubUpdaterService

  def create_repos(user, options = {})
    client = Octokit::Client.new(access_token: user.token)
    number = options[:amount] || 1
    number.times do |n|
      response = client.create_repository "HubGitterRepo-#{n}", private: true, description: "This is an auto-commiting private repository made with HubGitter"
      UserRepo.create!(user: user, repo_id: response[:id])
    end
  end

  def auto_commit_for(user)

  end


end
