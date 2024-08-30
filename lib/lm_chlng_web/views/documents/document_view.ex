defmodule LmChlngWeb.DocumentJSON do
  use JSONAPI.View, type: "documents"

  def fields do
    [:id, :plaintiffs, :defendants, :file_path, :processed]
  end
end
