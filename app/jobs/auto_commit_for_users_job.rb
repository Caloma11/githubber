class AutoCommitForUsersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    User.all.each do |user|
      rand(14).times { GithubUpdaterService.new(user).commit }
    end
  end
end
