defmodule AppWeb.PageController do
  use AppWeb, :controller
  alias App.Calculator

  require IEx

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def calculate(conn, %{"component" => component, "speed" => speed}) do
    speeds = Calculator.execute(component, String.to_integer(speed), 60, 110)
    render(conn, :calculate, layout: false, speeds: speeds, speed: speed, component: component)
  end
end
