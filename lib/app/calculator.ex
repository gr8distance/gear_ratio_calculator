defmodule App.Calculator do
  require IEx

  def execute(component, speed), do: execute(component, speed, 40, 120)

  def execute(component, speed, min_cadence, max_cadence) do
    yaml = parse_yaml()
    gear = yaml[component]
    chainrings = fetch_all_chainrings(gear)
    sprockets = fetch_all_sprockets(gear)

    calc_all_speeds(chainrings, sprockets, min_cadence, max_cadence)
    |> Enum.filter(&(speed - 0.3 <= &1.speed && &1.speed <= speed + 0.3))
    |> Enum.group_by(& &1.chainring)
  end

  def calc_all_speeds(chainrings, sprockets, min_cadence, max_cadence) do
    Enum.map(min_cadence..max_cadence, fn cadence ->
      Enum.map(chainrings, fn chainring ->
        Enum.map(sprockets, fn sprocket ->
          front = String.to_integer(chainring)
          rear = String.to_integer(sprocket)

          %{
            cadence: cadence,
            chainring: front,
            sprocket: rear,
            ratio: front / rear,
            speed: calc_speed(front, rear, cadence)
          }
        end)
      end)
    end)
    |> List.flatten()
  end

  def calc_speed(chainring, sprocket, cadence) do
    chainring / sprocket * cadence * 2.16 * 60 / 1000
  end

  def fetch_all_sprockets(gear) do
    gear["sprocket"]
    |> Map.values()
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
  end

  def fetch_all_chainrings(gear) do
    gear["chainring"]
    |> Map.values()
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
  end

  def parse_yaml do
    yaml_path()
    |> YamlElixir.read_from_file!(atoms: true)
  end

  def yaml_path, do: "priv/components/gear.yaml"
end
