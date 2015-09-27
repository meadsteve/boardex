defprotocol Boardex.Move.PlacePiece do

  defstruct position: nil, piece: nil

  @doc "returns the new square after applying piece_placement on board"
  def new_square(board, old_square, piece_placement)

end
