defmodule TopTenWeb.Plugs.UserIdentity do
  import Plug.Conn

  @max_age 60 * 60 * 24 * 365
  @cookie_name "user_identity"

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, @cookie_name) do
      nil ->
	# New user, create identity
	user_id = TopTen.UserIdentity.generate_user_id()
	user_name = TopTen.UserIdentity.generate_random_name()

	user_identity = %{
	  id: user_id,
	  name: user_name,
	  created_at: DateTime.utc_now() |> DateTime.to_iso8601()
	}

        cookie_value = Jason.encode!(user_identity)

	conn
	|> put_session(@cookie_name, user_identity)
	|> put_resp_cookie(@cookie_name, cookie_value, max_age: @max_age, http_only: true)
	|> assign(:current_user, user_identity)

      user_identity ->
	# Existing user

	conn
	|> assign(:current_user, user_identity)
    end
  end
  
end
