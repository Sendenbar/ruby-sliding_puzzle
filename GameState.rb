require_relative 'factorial'
require 'pry'

class GameState
  attr_accessor :state_array
  attr_accessor :distance
  attr_accessor :path
  
  def self.set_heuristic(heuristic)
    @@heuristic = heuristic
  end

  def self.set_dimensions(rows, columns)
    @@rows = rows
    @@columns = columns
    @@size = rows * columns
    @@empty = @@size
  end

  def initialize(state)
    @state_array = state
    @distance = 0
    @path = "" 
  end
  
  # Returns number of permutation of in lexicographical ordering
  def permutation_number
    number = 0
    unused = Array.new(@@size, true)
    (1..@@size).each do |i|
      l = 1
      j = 1
      while j != @state_array[i - 1] do
        l += 1 if unused[j - 1]
        j += 1
      end
      number += (l - 1) * (@@size - i).factorial
      unused[@state_array[i - 1] - 1] = false
    end
    return number
  end

  # Prints state in table form
  def print_state
    @@rows.times do |row|
      @@columns.times do |column|
        print '%4.4s' %  @state_array[row * @@columns + column].to_s," "
      end
      print "\n"
    end
    print "\n"
  end
  
  # The empty tile goes up
  def up!(position_of_empty_tile)
    @state_array[position_of_empty_tile] = @state_array[position_of_empty_tile - @@columns]
    @state_array[position_of_empty_tile - @@columns] = @@empty
    @path += "D"
    self
  end

  # The empty tile goes down
  def down!(position_of_empty_tile)
    @state_array[position_of_empty_tile] = @state_array[position_of_empty_tile + @@columns]
    @state_array[position_of_empty_tile + @@columns] = @@empty
    @path += "U"
    self
  end

  # The empty tile goes right
  def right!(position_of_empty_tile)
    @state_array[position_of_empty_tile] = @state_array[position_of_empty_tile + 1]
    @state_array[position_of_empty_tile + 1] = @@empty
    @path += "L"
    self
  end

  # The empty tile goes left
  def left!(position_of_empty_tile)
    @state_array[position_of_empty_tile]=@state_array[position_of_empty_tile - 1]
    @state_array[position_of_empty_tile - 1] = @@empty
    @path += "R"
    self
  end

  def get_neighbours
    neighbours = Array.new
    position_of_empty_tile = get_position_of_empty_tile

    # Push empty tile up unless already in the first row
    if position_of_empty_tile >= @@columns then
      neighbour = self.clone
      neighbour.distance += 1
      neighbour.up!(position_of_empty_tile)
      neighbours << neighbour
    end

    # Push empty tile down unless already in the last row
    if position_of_empty_tile < @@columns * (@@rows - 1) then
      neighbour = self.clone 
      neighbour.distance += 1
      neighbour.down!(position_of_empty_tile)
      neighbours << neighbour
    end

    # Push empty tile left unless already in the first column
    if (position_of_empty_tile % @@columns) != 0 then
      neighbour = self.clone
      neighbour.distance += 1
      neighbour.left!(position_of_empty_tile)
      neighbours << neighbour
    end
    
    # Push empty tile right unless already in the last column 
    if (position_of_empty_tile % @@columns) != @@columns - 1 then
      neighbour = self.clone
      neighbour.distance += 1
      neighbour.right!(position_of_empty_tile)
      neighbours << neighbour
    end

    return neighbours
  end

  def get_position_of_empty_tile
    @state_array.index(@@empty)
  end

  def clone
    new_state = GameState.new(@state_array.clone)
    new_state.distance = @distance
    new_state.path = @path
    return new_state
  end

  def random_move!(number)
   number.times do
    empty_tile = get_position_of_empty_tile
    i =  rand(4)
    case i
      when 0
        self.left!(empty_tile) if (empty_tile % @@columns) != 0
      when 1
        self.right!(empty_tile) if (empty_tile % @@columns) != @@columns - 1
      when 2
        self.up!(empty_tile) if empty_tile >= @@columns
      when 3
        self.down!(empty_tile) if empty_tile < @@columns * (@@rows - 1)
      else
        puts "OMGWTFERROR!!!"
    end
   end
   @path = ""
  end

  # Compares @state_array with sorted array of equal length
  def solved?
    return @state_array.eql?((1..(@state_array.size)).to_a)
  end

  # Returns "true" if permutation parity of @state_array (number of inversions) is even, "false" otherwise
  def parity_even?
    number_of_inversions = 0
    @@size.times do |i|
      (i..(@@size - 1)).each do |j|
        number_of_inversions += 1 if ((@state_array[i] > @state_array[j]) && (@state_array[i] != @@empty) && (@state_array[j] != @@empty))
      end
    end
    return number_of_inversions % 2 == 1 ? false : true
  end

  # Returns "true" if empty tile is on odd row when counting from bottom (the bottom line is counted as first)
  def empty_on_odd_row_from_bottom
    empty = get_position_of_empty_tile
    row = @@rows - empty / @@columns
    return row % 2 == 1 ? true : false 
  end
  
  # Returns "true" if the state is solvable, "false" otherwise
  def solvable?
    @@columns % 2 == 1 ? parity_even? : parity_even? == empty_on_odd_row_from_bottom
  end
  

  def eql?(other)
    @state_array == other.state_array
  end

  def <=>(other)
    estimated_distance <=> other.estimated_distance
  end

  def estimated_distance
    @@heuristic.distance(self) + @path.length
  end

end
