class GithubController < ApplicationController
  def repo
    GithubUpdaterService.new.create_repos(current_user, amount: params[:amount].to_i)
    redirect_to root_path
  end
end
