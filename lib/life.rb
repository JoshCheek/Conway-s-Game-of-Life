require 'set'

class GameOfLife
  
  def initialize(*cells)
    @cells = Set[*cells]
  end
  
  def alive?(x,y)
    @cells.include? [x,y]
  end
  
  def neighbours_at(x,y)
    count = 0
    neighboring_cells(x,y) { |x,y| count += 1 if alive? x, y }
    count
  end
  
  def neighboring_cells(x,y)
    [-1,0,1].each do |x_offset|
      [-1,0,1].each do |y_offset|
        next if 0 == x_offset && 0 == y_offset
        yield [x+x_offset, y+y_offset]
      end
    end
  end
  
end