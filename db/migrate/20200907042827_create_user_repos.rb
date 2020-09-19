class CreateUserRepos < ActiveRecord::Migration[6.0]
  def change
    create_table :user_repos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :repo_id

      t.timestamps
    end
  end
end
