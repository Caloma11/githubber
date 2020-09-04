require 'test_helper'

class GithubControllerTest < ActionDispatch::IntegrationTest
  test "should get repo" do
    get github_repo_url
    assert_response :success
  end

end
