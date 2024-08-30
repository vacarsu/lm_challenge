defmodule LmChlng.Repo do
  use Ecto.Repo,
    otp_app: :lm_chlng,
    adapter: Ecto.Adapters.Postgres
end
