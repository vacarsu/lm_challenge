defmodule LmChlng.Documents.Handlers.DocumentHandler do
  require Logger
  use Oban.Worker

  alias LmChlng.Documents.Finders.DocumentById
  alias LmChlng.Documents.Services.{CreateDocument, UpdateDocument}

  def perform(%{args: %{"id" => id}}) do
    document = DocumentById.find(id)
    {:ok, %{plaintiffs: plaintiffs, defendants: defendants}} = parse_file(document.file_path)

    Logger.debug(inspect plaintiffs)
    Logger.debug(inspect defendants)

    UpdateDocument.call(document, %{
      plaintiffs: plaintiffs,
      plaintiffs_hashed: plaintiffs,
      defendants: defendants,
      defendants_hashed: defendants,
      processed: true
    })
  end

  def parse_file(file_path) do
    stream = File.stream!(file_path, [:trim_bom])

    Saxy.parse_stream(stream, LmChlng.Documents.Handlers.DocumentParserHandler, %{
      chars: [],
      prev_chars: [],
      collecting: :plaintiffs,
      plaintiffs: nil,
      defendants: nil
    })
  end

  def create_document(params) do
    {:ok, document} = CreateDocument.call(params)
    create_job(document.id)
    document
  end

  def create_job(document_id) do
    %{id: document_id}
    |> new()
    |> Oban.insert()
  end
end
