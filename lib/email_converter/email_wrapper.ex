defmodule EmailConverter.EmailWrapper do
  def build_email(nil, _, _), do: nil
  def build_email(email, id, index) do
    message = Mail.build()
      |> put_to(email["to"])
      |> put_from(email["from"])
      |> put_cc(email["cc"])
      |> put_bcc(email["bcc"])
      |> put_subject(email["subject"])
      |> put_text(email["body"])
      |> Mail.Renderers.RFC2822.render

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

  defp put_to(message, ""), do: message
  defp put_to(message, nil), do: message
  defp put_to(message, value) do
    Mail.put_to(message, value)
  end

  defp put_from(message, ""), do: message
  defp put_from(message, nil), do: message
  defp put_from(message, value) when not is_nil(value) do
    Mail.put_from(message, value)
  end

  defp put_cc(message, ""), do: message
  defp put_cc(message, nil), do: message
  defp put_cc(message, value) when not is_nil(value) do
    Mail.put_cc(message, value)
  end

  defp put_bcc(message, ""), do: message
  defp put_bcc(message, nil), do: message
  defp put_bcc(message, value) when not is_nil(value) do
    Mail.put_bcc(message, value)
  end

  defp put_subject(message, ""), do: message
  defp put_subject(message, nil), do: message
  defp put_subject(message, value) when not is_nil(value) do
    Mail.put_subject(message, value)
  end

  defp put_text(message, ""), do: message
  defp put_text(message, nil), do: message
  defp put_text(message, value) when not is_nil(value) do
    Mail.put_text(message, value)
  end
end
