defmodule LmChlng.Documents.Services.CreateDocument do
  alias LmChlng.Repo
  alias LmChlng.Schema.Document

  def call(params) do
    changeset = Document.changeset(%Document{}, params)
    Repo.insert(changeset)
  end
end
