defmodule AppWeb.PageHTML do
  use AppWeb, :html

  embed_templates "page_html/*"

  def format(n) when is_float(n), do: Float.round(n, 2)
end
