defmodule LmChlngWeb.UploadLive do
  require Logger
  use LmChlngWeb, :live_view

  alias LmChlng.Documents.Handlers.DocumentHandler

  def render(assigns) do
    ~H"""
    <div>
      <form phx-submit="save" phx-change="validate" class="flex flex-col gap-4">
        <div class="container">
          <.live_file_input upload={@uploads.pdf} />
        </div>

        <.button phx-disable-with="Uploading..." class="w-full">Upload</.button>
      </form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> allow_upload(:pdf, accept: [".xml"])

    {:ok, socket}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    files =
      consume_uploaded_entries(socket, :pdf, fn %{path: path}, %{client_name: client_name} ->
        Logger.debug(client_name)
        dest = Application.app_dir(:lm_chlng, "priv/static/uploads")
        File.cp!(path, "#{dest}/#{client_name}")
        {:ok, "#{dest}/#{client_name}"}
      end)
    Logger.debug(inspect files)

    Enum.map(files, fn file ->
      DocumentHandler.create_document(%{file_path: file})
    end)

    {:noreply, socket}
  end
end
