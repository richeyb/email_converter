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
  defp greenhouse_url(path) do
    protocol = Application.get_env(:email_converter, :protocol) || "https"
    hostname = Application.get_env(:email_converter, :greenhouse_host)
    port     = Application.get_env(:email_converter, :port)
    port_string = if port do
      ":#{port}"
    else
      ""
    end
    "#{protocol}://#{hostname}#{port_string}/#{path}"
  end

  defp fetch(id, 3, _) do
    {:error, "Tried 3 times to fetch for #{id}. Giving up!"}
  end

  defp fetch(id, retries, api_key) do
    IO.puts "Fetching from #{greenhouse_url("v1/candidates/#{id}/activity_feed")}..."
    case HTTPoison.get(greenhouse_url("v1/candidates/#{id}/activity_feed"), headers(api_key)) do
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
