defmodule EmailConverter.EmailWrapper do
  use Timex
  alias MimeMail

  def build_email(nil, _, _), do: nil
  def build_email(email, id, index) do
    message = %MimeMail{
      headers: [
        to: [ %MimeMail.Address{address: email["to"]} ],
        from: [ %MimeMail.Address{address: email["from"]} ],
        cc: [ %MimeMail.Address{address: email["cc"]} ],
        bcc: [ %MimeMail.Address{address: email["bcc"]} ],
        subject: email["subject"],
        date: format_date(email["created_at"]),
        'content-type': { 'text/html', %{charset: "utf8"}},
      ],
      body: email["body"]
    }
    |> MimeMail.to_string

    IO.puts "Writing out output/#{id}-#{index}.eml..."
    case File.open "output/#{id}-#{index}.eml", [:write, :utf8] do
      {:ok, file} ->
        IO.binwrite file, message
        File.close(file)
      {:error, error} ->
        IO.puts "Error opening file: #{error}"
    end
  end

  # PRIVATE FUNCTIONS

  defp format_date(value) do
    value
    |> Timex.parse!("{ISO:Extended}")
    |> Timex.format!("{RFC1123}")
  end
end
