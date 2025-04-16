defmodule TopTenWeb.UserAuth do
  import Phoenix.Component
  import Phoenix.LiveView

  def on_mount(:default, _params, session, socket) do
    user_identity = session["user_identity"]

    user_identity = user_identity || %{
		      id: "unknown",
		      name: "Gäst",
		      created_at: DateTime.utc_now() || DateTime.to_iso8601()
    }

    {:cont, assign(socket, current_user: user_identity)}
  end
end
