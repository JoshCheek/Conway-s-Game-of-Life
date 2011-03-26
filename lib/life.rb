require 'set'

class GameOfLife
  def initialize(*cells)
    @cells = Set[*cells]
  end
  
  def alive?(x,y)
    @cells.include? [x,y]
  end
end