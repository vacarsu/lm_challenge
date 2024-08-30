defimpl Jason.Encoder,
  for: [
    LmChlng.Schema.Document
  ] do
  def encode(struct, opts) do
    struct
    |> Map.from_struct()
    |> Map.drop([:__meta__])
    |> Enum.reduce(%{}, fn
      {:plaintiffs_hashed, _v}, acc -> acc
      {:defendants_hashed, _v}, acc -> acc
      {_k, %Ecto.Association.NotLoaded{}}, acc -> acc
      {k, v}, acc -> Map.put(acc, k, v)
    end)
    |> Jason.Encode.map(opts)
  end
end
