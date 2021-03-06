require 'set'

class GameOfLife
  
  attr_accessor :width , :height , :cells

  def initialize(*cells)
    cells << Hash[:width,60, :height,40] unless cells.last.kind_of? Hash
    options = cells.pop
    @cells  = Set[*cells]
    @width  = options[:width]
    @height = options[:height]
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
    self
  end
    
  def to_a
    Array.new(height) { |y| Array.new(width) { |x| alive? x , y or nil } }
  end
  
  def ==(other)
    cells   ==  other.cells   && 
    width   ==  other.width   &&
    height  ==  other.height
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
    return 3 == neighbours(x,y)  if not alive? x , y
    return false                 if neighbours(x,y) < 2
    return true                  if neighbours(x,y) < 4
    return false
  end
  
end

class << GameOfLife
  def [](map=nil)
    args = Array.new
    unless map.nil?
      rows = map.split("\n").map { |row| row.gsub(/\s/,'').split(//) }
      width = rows.first.size
      raise "rows should all be the same length" unless rows.all? { |row| row.size == width }
      dimensions = { :height => rows.size , :width => width }
      rows.each_with_index do |row,y|
        row.each_with_index do |char,x|
          next if char == '.'
          args << [x,y]
        end
      end
      args << dimensions
    end
    new(*args)
  end
end

