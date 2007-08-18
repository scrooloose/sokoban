module Movable
  class InvalidMoveError < StandardError; end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def before_move(symbol)
      @before_move_callback = symbol
    end
    attr_reader :before_move_callback
    
    def blocked_by(*pieces)
      @blockers = pieces
    end
    
    def blockers
      @blockers.map do |name|
        const_get(name)
      end
    end
  end
  
  def position_for(xdiff, ydiff)
    xnew, ynew = x + xdiff, y + ydiff
  end

  def move_down
    move(0, 1)
  end

  def move_left
    move(-1, 0)
  end

  def move_right
    move(1, 0)
  end

  def move_up
    move(0, -1)
  end

  def move(xdiff, ydiff)
    xnew, ynew = position_for(xdiff, ydiff)
    raise(InvalidMoveError, "Cannot move #{self.class} to #{xnew}, #{ynew}") unless blocked?(xnew, ynew)
    send(self.class.before_move_callback, xdiff, ydiff) if self.class.before_move_callback
    @x, @y = xnew, ynew
  end
  
  def blocked?(xnew, ynew)
    pieces_on_square = @stage.pieces_for(xnew, ynew).map {|p| p.class}
    !pieces_on_square.include_any? *self.class.blockers
  end
end