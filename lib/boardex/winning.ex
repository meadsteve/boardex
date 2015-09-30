defprotocol Boardex.Winning do
  @doc "Returns the winner for the given board or :noone if the game is still in progress"
  def winner(board)
end
