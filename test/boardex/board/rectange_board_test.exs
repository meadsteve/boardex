defmodule Boardex.Board.RectangleBoardTest do
  use ExUnit.Case
  alias Boardex.Board
  alias Boardex.Board.RectangleBoard
  alias Boardex.Square

  defp play(board, piece, position) do
    move =  %Boardex.Move.PlacePiece{position: position, piece: piece}
    Board.make_move(board, move)
  end

  test "New board empty board structs are created with 2d coords" do
    %{squares: squares} = RectangleBoard.new(2, 2)
    assert Enum.count(squares) == (2 * 2)
    assert Enum.member?(squares, %Square{position: {1,1}, contents: :empty})
    assert Enum.member?(squares, %Square{position: {1,2}, contents: :empty})
    assert Enum.member?(squares, %Square{position: {2,1}, contents: :empty})
    assert Enum.member?(squares, %Square{position: {2,2}, contents: :empty})
  end


  test "The implementation below updates empty squares to the move piece" do
    board = RectangleBoard.new(3, 3)

    updated_board = board
      |> play(:cross, {1,2})
      |> play(:circle, {2,2})

      assert Enum.member?(updated_board.squares, %Square{position: {1,2}, contents: :cross})
      assert Enum.member?(updated_board.squares, %Square{position: {2,2}, contents: :circle})
  end

  test "The implementation below can only make moves on empty squares" do
    board = RectangleBoard.new(3, 3)
    move = %Boardex.Move.PlacePiece{position: {1, 2}, piece: :cross}
    updated_board = Board.make_move(board, move)
    assert catch_error(Board.make_move(updated_board, move)) == :function_clause
  end

  test "The implementation only allows naughts and crosses to be placed" do
    board = RectangleBoard.new(3, 3)
    move = %Boardex.Move.PlacePiece{position: {1, 2}, piece: :banana}
    assert catch_error(Board.make_move(board, move)) == :function_clause
  end

  test "no one has won at the start of the game" do
    board = RectangleBoard.new(3, 3)
    assert Boardex.Winning.winner(board) == :noone
  end

  test "a full board is a draw" do
     board = RectangleBoard.new(3, 3)
       |> play(:cross,  {1,1})
       |> play(:circle, {1,2})
       |> play(:cross,  {2,1})
       |> play(:circle, {2,2})
       |> play(:cross,  {3,2})
       |> play(:circle, {3,1})
       |> play(:cross,  {1,3})
       |> play(:circle, {2,3})
       |> play(:cross,  {3,3})
     assert Boardex.Winning.winner(board) == :draw
  end
end

### The implemntation below defines naughts and crosses.
defimpl Boardex.Move.PlacePiece, for: Boardex.Board.RectangleBoard do
  alias Boardex.Move.PlacePiece
  def new_square(_, %{contents: :empty} = old_square, %PlacePiece{piece: piece})
    when piece == :cross or piece == :circle
  do
    %{old_square | contents: piece}
  end
end

defimpl Boardex.Winning, for: Boardex.Board.RectangleBoard do
  def winner(board) do
    cond do
      piece_won?(board, :cross)  -> :cross
      piece_won?(board, :circle) -> :circle
      board_full?(board)         -> :draw
      true                       -> :noone
    end
  end

  defp piece_won?(board, piece) do
    false
  end

  defp board_full?(board) do
    empty_squares = board.squares
      |> Enum.filter(fn(square) -> square.contents == :empty end)
      |> Enum.count
    empty_squares == 0
  end

end
