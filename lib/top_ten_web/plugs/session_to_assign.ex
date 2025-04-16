defmodule TopTenWeb.Plugs.SessionToAssign do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    session_variable = get_session(conn, opts)
    assign(conn, opts, session_variable)
  end
  
end
