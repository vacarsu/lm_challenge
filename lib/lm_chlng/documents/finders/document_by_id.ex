defmodule LmChlng.Documents.Finders.DocumentById do
  alias LmChlng.Repo
  alias LmChlng.Schema.Document

  def find(id) do
    Repo.get_by(Document, id: id)
  end
end
