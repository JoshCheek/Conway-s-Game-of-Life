require 'set'

class GameOfLife
  
  def initialize(*cells)
    @cells = Set[*cells]
  end
  
  def alive?(x,y)
    @cells.include? [x,y]
  end
  
  def neighbours(x,y)
    count = 0
    neighboring_cells(x,y) { |x,y| count += 1 if alive? x, y }
    count
  end

private
  
  def neighboring_cells(x,y)
    [-1,0,1].each do |x_offset|
      [-1,0,1].each do |y_offset|
        next if x_offset.zero? && y_offset.zero?
        yield [x+x_offset, y+y_offset]
      end
    end
  end
  
end