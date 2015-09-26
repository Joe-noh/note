use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :note, Note.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Set a higher stacktrace during test
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :note, Note.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "note_test",
  hostname: "192.168.99.100",
  port: 32768,
  pool: Ecto.Adapters.SQL.Sandbox

config :comeonin, bcrypt_log_rounds: 4
