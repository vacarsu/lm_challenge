defmodule LmChlng.Schema.Document do
  use Ecto.Schema
  import Ecto.Changeset

  schema "documents" do
    field :plaintiffs, LmChlng.Vault.Binary
    field :plaintiffs_hashed, LmChlng.Vault.Hmac, redact: true
    field :defendants, LmChlng.Vault.Binary
    field :defendants_hashed, LmChlng.Vault.Hmac, redact: true
    field :file_path, :string
    field :processed, :boolean, default: false
  end

  @fields [
    :plaintiffs,
    :plaintiffs_hashed,
    :defendants,
    :defendants_hashed,
    :file_path,
    :processed
  ]

  def changeset(document, params) do
    document
    |> cast(params, @fields)
  end
end
