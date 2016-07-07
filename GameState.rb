class GameState
  include Comparable
  
  attr_accessor :state_array
  attr_accessor :distance
  attr_accessor :path
  attr_accessor :estimated_distance
  attr_accessor :rows
  attr_accessor :columns
  attr_accessor :empty
  
  def initialize
    @state_array = Array.new
    @distance = 0
    @empty = 9
  end

  def permutation_number
    number=0;
    unused=Array.new(9,true)
    (1..9).each do |i|
      l=1
      j=1
      while j != @state_array[i-1] do
        l+=1 if unused[j-1]
        j+=1
      end
        number+= (l-1)*(9-i).factorial
        unused[@state_array[i-1]-1]=false;
    end
    return number
  end

  def print_state_refactoring
    @rows.times do |row|
      @columns.times do |column|
        print @state_array[row * @columns + column].to_s," "
      end
      print "\n"
    end
  end
  
  def print_state
    puts
    puts @state_array[0].to_s + " " + @state_array[1].to_s + " " + @state_array[2].to_s
    puts @state_array[3].to_s + " " + @state_array[4].to_s + " " + @state_array[5].to_s
    puts @state_array[6].to_s + " " + @state_array[7].to_s + " " + @state_array[8].to_s
    puts
  end

  #The empty tile (nine) goes up
  def up(position_of_empty_tile)
    @state_array[position_of_empty_tile] = @state_array[position_of_empty_tile - @columns]
    @state_array[position_of_empty_tile - @columns] = @empty
    @path += "D"
  end

  #The empty tile (nine) goes down
  def down(position_of_empty_tile)
    @state_array[position_of_empty_tile] = @state_array[position_of_empty_tile + @columns]
    @state_array[position_of_empty_tile + @columns] = @empty
    @path += "U"
  end

  #The empty tile (nine) goes right
  def right(position_of_empty_tile)
    @state_array[position_of_empty_tile] = @state_array[position_of_empty_tile + 1]
    @state_array[position_of_empty_tile + 1] = @empty
    @path += "L"
  end

  # The empty tile (nine) goes left
  def left(position_of_empty_tile)
    @state_array[position_of_empty_tile]=@state_array[position_of_empty_tile - 1]
    @state_array[position_of_empty_tile - 1] = @empty
    @path += "R"
  end

  def get_neighbours
    neighbours = Array.new
    position_of_empty_tile = get_position_of_empty_tile

    # Push empty tile up unless already in the first row
    if position_of_empty_tile >= @columns then
      neighbour = self.clone
      neighbour.up(position_of_empty_tile)
      neighbours << neighbour
    end

    # Push empty tile down unless already in the last row
    if position_of_empty_tile < @columns * (@rows - 1) then
      neighbour = self.clone
      neighbour.down(position_of_empty_tile)
      neighbours << neighbour
    end

    # Push empty tile left unless already in the first column
    if (position_of_empty_tile % @columns) != 0 then
      neighbour = self.clone
      neighbour.left(position_of_empty_tile)
      neighbours << neighbour
    end
    
    # Push empty tile right unless already in the last column 
    if (position_of_empty_tile % @columns) != @columns - 1 then
      neighbour = self.clone
      neighbour.right(position_of_empty_tile)
      neighbours << neighbour
    end

    return neighbours
  end

  def get_position_of_empty_tile
    @state_array.index(@empty)
  end

  def clone
    new_state=GameState.new
    new_state.state_array=@state_array.clone
    new_state.distance=@distance+1
    new_state.path=@path
    return new_state
  end

  # Compares @state_array with sorted array of equal length
  def solved?
    return @state_array.eql?((0..(@state_array.size - 1)).to_a)
  end

  def parity
    transpozice=0
      9.times do |i|
         (i..8).each do |j|
           transpozice+=1 if ((@state_array[i]>@state_array[j]) && (@state_array[i]!=9) && (@state_array[j]!=9))
          end
       end
    return transpozice%2==1 ? true : false
  end

  def <=>(another)
    @estimated_distance<=>another.estimated_distance
  end
end
