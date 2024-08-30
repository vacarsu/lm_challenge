defmodule LmChlng.Documents.Services.UpdateDocument do
  alias LmChlng.Repo
  alias LmChlng.Schema.Document

  def call(%Document{} = document, params) do
    changeset = Document.changeset(document, params)
    Repo.update(changeset)
  end
end
