class GithubController < ApplicationController
  def repo
    GithubUpdaterService.new(current_user).create_repos(amount: params[:amount].to_i)
    redirect_to root_path
  end

  def delete_repos
    GithubUpdaterService.new(current_user).delete_all_repos
    redirect_to root_path
  end
end
