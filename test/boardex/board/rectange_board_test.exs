defmodule Boardex.Board.RectangleBoardTest do
  use ExUnit.Case
  alias Boardex.Board
  alias Boardex.Board.RectangleBoard
  alias Boardex.Square

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
    first_move = %Boardex.Move.PlacePiece{position: {1,2}, piece: :cross}
    second_move = %Boardex.Move.PlacePiece{position: {2,2}, piece: :circle}

    updated_board = board
      |> Board.make_move(first_move)
      |> Board.make_move(second_move)

      assert Enum.member?(updated_board.squares, %Square{position: {1,2}, contents: :cross})
      assert Enum.member?(updated_board.squares, %Square{position: {2,2}, contents: :circle})
  end

  test "The implementation below can only make moves on empty squares" do
    board = RectangleBoard.new(3, 3)
    move = %Boardex.Move.PlacePiece{position: {1, 2}, piece: :cross}
    updated_board = Board.make_move(board, move)
    assert catch_error(Board.make_move(updated_board, move)) == :function_clause
  end
end

defimpl Boardex.Move.PlacePiece, for: Boardex.Board.RectangleBoard do
  alias Boardex.Move.PlacePiece
  def new_square(_, %{contents: :empty} = old_square, %PlacePiece{} = move) do
    new_piece = move.piece
    %{old_square | contents: new_piece}
  end
end
