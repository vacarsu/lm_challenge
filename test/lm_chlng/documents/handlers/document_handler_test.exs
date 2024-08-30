defmodule LmChlng.DocumentHandlerTest do
  use LmChlng.DataCase
  alias LmChlng.Documents.Handlers.DocumentHandler
  alias LmChlng.Documents.Services.CreateDocument
  alias LmChlng.Documents.Finders.DocumentById

  @upload_dir Application.app_dir(:lm_chlng, "priv/static/uploads")

  test "create_document creates a document in the database and process it" do
    new_document = DocumentHandler.create_document(%{
      file_path: "#{@upload_dir}/A.xml"
    })

    assert new_document.processed == false

    document = DocumentById.find(new_document.id)

    assert document.processed == true
  end

  test "perform finds the correct plaintiffs and defendants for A.xml" do
    {:ok, new_document} = CreateDocument.call(%{file_path: "#{@upload_dir}/A.xml"})

    DocumentHandler.perform(%{args: %{"id" => new_document.id}})

    document = DocumentById.find(new_document.id)

    assert document.plaintiffs == "ANGELO ANGELES, an individual,"
    assert document.defendants == "HILL-ROM COMPANY, INC., an Indiana ) corporation; and DOES 1 through 100, inclusive, )"
  end

  test "perform finds the correct plaintiffs and defendants for B.xml" do
    {:ok, new_document} = CreateDocument.call(%{file_path: "#{@upload_dir}/B.xml"})

    DocumentHandler.perform(%{args: %{"id" => new_document.id}})

    document = DocumentById.find(new_document.id)

    assert document.plaintiffs == "KUSUMA AMBELGAR,    |    No."
    assert document.defendants == "THIRUMALLAILLC, d/b/a    i COMMODORE MOTEL, DOES 1-IO,    j inclusive.,    j"
  end

  test "perform finds the correct plaintiffs and defendants for C.xml" do
    {:ok, new_document} = CreateDocument.call(%{file_path: "#{@upload_dir}/C.xml"})

    DocumentHandler.perform(%{args: %{"id" => new_document.id}})

    document = DocumentById.find(new_document.id)

    assert document.plaintiffs == "ALBA ALVARADO, an individual;"
    assert document.defendants == "LAGUARDIA ENTERPRISES, INC., a California Corporation, dba SONSONATE GRILL; and DOES 1 through 25, inclusive,"
  end
end
