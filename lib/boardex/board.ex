defprotocol Boardex.Board do
  @doc "Updates the board after making the specified move"
  def make_move(board, move)
end
