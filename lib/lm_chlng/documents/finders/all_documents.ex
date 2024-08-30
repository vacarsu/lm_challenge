defmodule LmChlng.Documents.Finders.AllDocuments do
  alias LmChlng.Repo
  alias LmChlng.Schema.Document

  def find do
    Repo.all(Document)
  end
end
