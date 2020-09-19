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
    end
  end

  def delete_all_repos
    @user.user_repos.each do |repo|
      @client.delete_repository(repo.repo_id.to_i)
    end
    @user.user_repos.destroy_all
  end

  def auto_commit_for

  end


end
