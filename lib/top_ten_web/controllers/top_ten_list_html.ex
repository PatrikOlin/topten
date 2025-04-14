defmodule TopTenWeb.TopTenListHTML do
  use TopTenWeb, :html

  embed_templates "top_ten_list_html/*"

  @doc """
  Renders a top_ten_list form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def top_ten_list_form(assigns)
end
