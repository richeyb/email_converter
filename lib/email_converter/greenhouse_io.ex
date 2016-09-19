defmodule EmailConverter.GreenhouseIo do
  defp headers(api_key) do
    %{
      "Authorization" => "Basic #{Base.encode64(api_key)}"
    }
  end

  def fetch(id, api_key) do
    fetch(id, 0, api_key)
  end

  # PRIVATE FUNCTIONS
  defp fetch(id, 3, _) do
    {:error, "Tried 3 times to fetch for #{id}. Giving up!"}
  end

  defp fetch(id, retries, api_key) do
    case HTTPoison.get("http://localhost-api.greenhouse.io:3001/v1/candidates/#{id}/activity_feed", headers(api_key)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 429}} ->
        IO.puts "Rate limit hit; sleeping for 10 seconds..."
        :timer.sleep(10000)
        IO.puts "Retrying #{id}..."
        fetch(id, retries + 1, api_key)
      {:error, error} ->
        IO.puts "An error occurred!\n#{inspect(error)}; sleeping for 10 seconds..."
        :timer.sleep(10000)
        IO.puts "Retrying #{id}..."
        fetch(id, retries + 1, api_key)
    end
  end
end
