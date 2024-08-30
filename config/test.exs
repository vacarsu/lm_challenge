import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :lm_chlng, LmChlng.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PW"),
  hostname: System.get_env("DB_HOST"),
  database: System.get_env("DB_NAME"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lm_chlng, LmChlngWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "58el9zkIsiQE9mrUc75RUKZrwucDDTuEi32fIpq/LVxqKQlIfiOm87X5kC5Wfmy9",
  server: false

# In test we don't send emails.
config :lm_chlng, LmChlng.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :lm_chlng, LmChlng.Vault,
  ciphers: [
    default: {
      Cloak.Ciphers.AES.GCM,
      tag: "AES.GCM.V1",
      key: Base.decode64!(System.get_env("CLOAK_VAULT_KEY")),
      iv_length: 12
    }
  ]

config :lm_chlng, LmChlng.Vault.Hmac,
  algorithm: :sha512,
  secret: System.get_env("CLOAK_HASH_SECRET")

config :lm_chlng, Oban,
  engine: Oban.Engines.Basic,
  queues: [default: 10],
  repo: LmChlng.Repo,
  testing: :inline
