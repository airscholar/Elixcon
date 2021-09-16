defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_odd_grid()

    # |> hash_to_color() |> color_to_identicon() |> identicon_to_svg()
  end

  def filter_odd_grid(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter(grid, fn {x, _index} -> rem(x, 2) == 0 end)

    %Identicon.Image{image | grid: grid}
  end

  def pick_color(image) do
    %Identicon.Image{hex: [r, g, b | _tail]} = image
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  @spec hash_input(any) :: %Identicon.Image{color: nil, hex: [byte], image: nil}
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
