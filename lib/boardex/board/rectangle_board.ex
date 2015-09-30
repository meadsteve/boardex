defmodule Boardex.Board.RectangleBoard do
  alias Boardex.Square

  defstruct squares: [], x_max: 0, y_max: 0

  def new(x_max, y_max) do
    squares = for x <- 1..x_max, y <-1..y_max do
      %Square{position: {x,y}}
    end

    %__MODULE__{squares: squares, x_max: x_max, y_max: y_max}
  end
end

defimpl Boardex.Board, for: Boardex.Board.RectangleBoard do
  alias Boardex.Board.RectangleBoard
  alias Boardex.Move.PlacePiece

  def make_move(board, %PlacePiece{} = move) do
    %{position: placed_position} = move

    updated_squares = board.squares
      |> Enum.map(fn
        (%{position: position} = square) when (placed_position == position)
          -> PlacePiece.new_square(board, square, move)
        square
          -> square
      end)
    %RectangleBoard{squares: updated_squares}
  end

end
