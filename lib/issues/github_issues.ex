defmodule Issues.GithubIssues do

  @user_agent [ {"User-agent", "Elixir santos.eduardothomaz@gmail.com"}]
  @github_url Application.get_env(:issues, :github_url)


  def fetch(user, project) do
    get_user_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end


  def get_user_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end


  def handle_response({:ok, %{status_code: 200, body: body}}) do
    %{status_code: 200,
      body: Poison.Parser.parse!(body)}
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    %{status_code: status_code,
      body: Poison.Parser.parse!(body)}
  end
end
