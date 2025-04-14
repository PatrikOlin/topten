defmodule TopTen.Repo do
  use Ecto.Repo,
    otp_app: :top_ten,
    adapter: Ecto.Adapters.Postgres
end
