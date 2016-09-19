defmodule Mix.Tasks.Convert do
  use Mix.Task
  alias EmailConverter

  @shortdoc "Runs the Email Conversion job with the configured api key"

  def run(_args) do
    Mix.shell.info "Running Email Conversion job..."
    EmailConverter.run
  end
end
