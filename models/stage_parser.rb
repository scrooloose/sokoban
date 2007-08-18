class StageParser
  def self.parse(lines)
    s = Stage.new
    pieces = []
    lines.each_with_index do |line, line_index|
      line = line.to_char_array.select{|c| c != "\n"}
      line.each_with_index do |char, char_index|
        pieces << GamePiece.pieces_for(char, char_index, line_index, s)
      end
    end

    s.pieces = pieces.flatten
    s
  end
end
