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
  
  def tick!
    new_cells = Set.new
    potential_cells { |cell| new_cells << cell if alive_tomorrow?(*cell) }
    @cells = new_cells
  end
  
  def width
    60
  end
  
  def height
    40
  end
  
  def to_a
    Array.new(height) { Array.new(width) { nil } }
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
  
  def potential_cells(&block)
    potentials = Set.new
    @cells.each do |cell|
      potentials << cell
      neighboring_cells(*cell) do |adjacent_cell|
        potentials << adjacent_cell
      end
    end
    potentials.each(&block)
  end
  
  def alive_tomorrow?(x,y)
    if alive? x , y
      return false if neighbours(x,y) < 2
      return true  if neighbours(x,y) < 4
      return false
    else
      neighbours(x,y) == 3
    end
  end
  
end



