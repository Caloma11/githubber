class Api::V1::GithubController < Api::V1::BaseController

  def manual
    if params[:token] == "batata_frita"
      begin
        AutoCommitForUsersJob.perform_later
        render_success
      rescue
        render_error
      end
    else
      render_error
    end
  end

  private

  def render_error
    render json: { errors: "Ooopsie!" },
      status: :unprocessable_entity
  end

  def render_success
    render json: { message: "All good!" },
      status: :ok
  end
end
