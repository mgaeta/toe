module PlayHelper
  # 0|1|2
  # -----
  # 3|4|5
  # -----
  # 6|7|8

  WIN = 10
  LOSE = -10
  TIE = 1
  CONTINUE = 0

  def printBoard(board)
    board.scan(/.../).join("\n")
  end

  def openSpaces(board)
    board.split("").each_with_index.map {|x,i| i if x == " "}.compact
  end

  def isFull?(board)
    board.count(" ") == 0
  end

  def padBoard(board)
    board + " " * (9 - board.size)
  end

  def isValid?(board)
    board.size == 9 && board.count("xo ") == 9
  end

  def spaceOccupied?(board, i)
    board[i] != " "
  end

  def setBoard(board, c, i)
    board.dup.tap {|b| b[i] = c}
  end

  def rowWinner(*row)
    return row.first if row.all? {|x| x == row.first}
    " "
  end

  def scoreWinner(winner)
    winner == "o" ? WIN : LOSE
  end

  def scoreTable(board)
    for i in 0..2
      r = rowWinner(board[i * 3], board[i * 3 + 1], board[i * 3 + 2])
      return scoreWinner(r) if r != " "

      c = rowWinner(board[i], board[3 + i], board[6 + i])
      return scoreWinner(c) if c != " "
    end

    for i in 0..1
      d = rowWinner(board[i * 2], board[4], board[8 - i * 2])
      return scoreWinner(d) if d != " "
    end

    isFull?(board) ? TIE : CONTINUE
  end

  def mapMin(m)
    m.min_by {|k,v| v}
  end

  def mapMax(m)
    m.max_by {|k,v| v}
  end

  def scoreMoves(board, adversary)
    moves = {}
    openSpaces(board).each do |i|
      newBoard = setBoard(board, adversary ? "x" : "o", i)
      score = scoreTable(newBoard)

      return [i, score] if (score != CONTINUE)

      moves[i] = scoreMoves(newBoard, !adversary)[1]
    end

    adversary ? mapMin(moves) : mapMax(moves)
  end

  def nextMove(board)
    scoreMoves(board, false)[0]
  end

  empty_board = "         "
  tie_board  = "ooxxxooxo"
  win_board  = "ooo      "
  lose_board  = "x   x   x"
  invalid_board  = "xxx"

  # isFull?(empty_board) == false
  # isFull?(tie_board) == true
  # isValid?(invalid_board) == false
  # isValid?(tie_board) == true
  # openSpaces(tie_board) == []
  # openSpaces(empty_board) == (0..8).to_a
  # spaceOccupied?(tie_board, 0) == true
  # spaceOccupied?(empty_board, 0) == false
  # rowWinner("x", "x", "x") == "x"
  # rowWinner("x", "o", "x") == " "
  # rowWinner("x", "x", " ") == " "
  # rowWinner(" ", " ", " ") == " "
  # scoreTable(empty_board) == CONTINUE
  # scoreTable("xo       ") == CONTINUE
  # scoreTable(win_board) == WIN
  # scoreTable(lose_board) == LOSE
  # scoreTable(tie_board) == TIE
  # setBoard(empty_board, "x", 0) == "x        "
  # setBoard(tie_board, "o", 7) == "ooxxxoooo"
  # mapMin({0 => 10, 1 => 2, 3 => 5}) == [1, 2]
  # mapMax({0 => 10, 1 => 2, 3 => 5}) == [0, 10]
  # nextMove("xoxoxx  o") == 6

  def play()
    board = "         "
    while (scoreTable(board) == CONTINUE)
      while (true)
        puts "your move: "
        i = gets.to_i
        if (spaceOccupied?(board, i))
          puts "taken"
        else
          board = setBoard(board, "x", i)
          puts printBoard(board)
          break
        end
      end

      return"tie" if scoreTable(board) == TIE

      board = setBoard(board, "o", nextMove(board))
      puts printBoard(board)

      return "you lose" if scoreTable(board) == WIN
      return "tie" if scoreTable(board) == TIE
    end
  end

  # play()
end
