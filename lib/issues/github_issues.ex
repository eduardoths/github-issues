defmodule Issues.GithubIssues do

  @user_agent [ {"User-agent", "Elixir santos.eduardothomaz@gmail.com"}]


  def fetch(user, project) do
    get_user_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end


  def get_user_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end


  def handle_response({:ok, %{status_code: 200, body: body}}) do
    %{status: :ok, status_code: 200, body: body}
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    %{status: :error, status_code: status_code, body: body}
  end
end