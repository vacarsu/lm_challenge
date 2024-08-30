defmodule LmChlngWeb.DocumentControllerTest do
  use LmChlngWeb.ConnCase

  @upload_dir Application.app_dir(:lm_chlng, "priv/static/uploads")

  test "GET /api/documents/{id} return one document", %{conn: conn} do
    {:ok, document} = LmChlng.Documents.Services.CreateDocument.call(%{file_path: "#{@upload_dir}/A.xml"})

    conn = get(conn, ~p"/api/documents/#{document.id}")

    assert json_response(conn, 200)["data"]["type"] == "document"
    assert json_response(conn, 200)["data"]["attributes"]["id"] == document.id
  end

  test "GET /api/documents/", %{conn: conn} do
    LmChlng.Documents.Services.CreateDocument.call(%{file_path: "#{@upload_dir}/A.xml"})
    LmChlng.Documents.Services.CreateDocument.call(%{file_path: "#{@upload_dir}/B.xml"})
    LmChlng.Documents.Services.CreateDocument.call(%{file_path: "#{@upload_dir}/C.xml"})
    conn = get(conn, ~p"/api/documents/")

    assert length(json_response(conn, 200)["data"]) > 0
  end
end
