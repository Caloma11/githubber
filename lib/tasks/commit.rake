namespace :commit do
  desc "Creating fake commits for everyone"
  task all: :environment do |t, args|
    AutoCommitForUsersJob.perform_later
  end
end
