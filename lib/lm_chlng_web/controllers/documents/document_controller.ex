defmodule LmChlngWeb.DocumentController do
  use LmChlngWeb, :controller
  alias LmChlng.Documents.Finders.{AllDocuments, DocumentById}

  def index(conn, _params) do
    documents = AllDocuments.find()

    render(conn, :index, %{data: documents})
  end

  def show(conn, %{"id" => id}) do
    document = DocumentById.find(id)
    # LmChlngWeb.DocumentJSON.show(document, conn, %{})
    render(conn, :show, %{data: document})
  end
end
