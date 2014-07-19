include PlayHelper

class PlayController < ApplicationController
  def index
    if (params.has_key?(:board) && isValid?(padBoard(params[:board])))
      b = padBoard(params[:board])
      if (scoreTable(b) == TIE)
        @board = b
        @done = "i don't lose"
        return
      end

      @board = setBoard(b, "o", nextMove(b))
      score = scoreTable(@board)
      if (score == TIE)
        @done = "i don't lose"
      elsif (score == WIN)
        @done = "you lose"
      end
    else
      @board = "         "
    end
  end
end
