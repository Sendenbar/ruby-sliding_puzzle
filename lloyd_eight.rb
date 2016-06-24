require 'pry'
require './heuristics.rb'
require './priority_queue.rb'

class Fixnum
  def factorial
    (2..self).reduce(:*) || 1
  end
end

class BFSGameSolver
  attr_accessor :list_of_states
  attr_accessor :q
  attr_accessor :start_state


  def set_start_state(array)
    @start_state=GameState.new
  #  @start_state.state_array = gets.split.to_a
    @start_state.state_array = array
    @start_state.path=""
  end

  def solve
    start_time=Time.new
    if @start_state.solvable? then
      list_of_states=Array.new(362880,false)
      q=Queue.new
      q.push(@start_state)
      @counter=0
      @current_state=@start_state
      while (!q.empty?&&!@current_state.solved?) do
        @current_state=q.pop
        @counter+=1
        @current_state.get_neighbours.each do |neighbour|
          if neighbour.solved? then
            @solved=true
            @current_state=neighbour
          end
          if list_of_states[neighbour.permutation_number]==false
            q.push(neighbour)
            list_of_states[neighbour.permutation_number]=true
          end
        end
        break if @solved
      end
      print_output
    else
      puts "Tento stav je neřešitelný"
    end


    end_time=Time.new
    puts (end_time-start_time)*1000
  end

  def print_output
    puts "Stačí #{@current_state.distance} kroků."
    puts @current_state.path
    puts "Algoritmus prošel #{@counter} vrcholy."
  end

end

class AStarGameSolver
  attr_accessor :list_of_states
  attr_accessor :q
  attr_accessor :start_state
  attr_accessor :heuristic


  def set_start_state(array,h)
    @start_state=GameState.new
  #  @start_state.state_array = gets.split.to_a
    @start_state.state_array = array
    @start_state.path=""
    @heuristic=h
  end

  def solve
    start_time=Time.new
    if @start_state.solvable? then
      list_of_states=Array.new(362880,false)
      q=PriorityQueue.new 
      @start_state.estimated_distance=@heuristic.value(@start_state)
      q.enqueue(@start_state)
      @counter=0
      @current_state=@start_state
      while (!q.empty?&&!@current_state.solved?) do
        #if @counter%100==0 then
        #  binding.pry
        #end
        @current_state=q.dequeue
        @counter+=1
        @current_state.get_neighbours.each do |neighbour|
          if neighbour.solved? then
            @solved=true
            @current_state=neighbour
          end
          if list_of_states[neighbour.permutation_number]==false
            neighbour.estimated_distance=@heuristic.value(neighbour)+neighbour.distance
            q.enqueue(neighbour)
            list_of_states[neighbour.permutation_number]=true
          end
        end
        break if @solved
      end
      print_output
    else
      puts "Tento stav je neřešitelný"
    end

    end_time=Time.new
    puts (end_time-start_time)*1000
  end

  def print_output
    puts "Stačí #{@current_state.distance} kroků."
    puts @current_state.path
    puts "Algoritmus prošel #{@counter} vrcholy."
  end

end

class BFSCounter
  attr_accessor :list_of_states
  attr_accessor :q
  attr_accessor :start_state


  def set_start_state
    @start_state=GameState.new
  #  @start_state.state_array = gets.split.to_a
    @start_state.state_array = [1,2,3,4,5,6,7,8,9]
    @start_state.path=""
  end

  def solve
    start_time=Time.new
    @list_of_states=Array.new(362880,false)
    q=Queue.new
    q.push(@start_state)
    @list_of_states[0]=0
    @current_state=@start_state
    while !q.empty? do
      @current_state=q.pop
      @current_state.get_neighbours.each do |neighbour|
        if @list_of_states[neighbour.permutation_number]==false
          q.push(neighbour)
          @list_of_states[neighbour.permutation_number]=neighbour.distance
          if neighbour.distance==31
            neighbour.print_state
            puts neighbour.permutation_number
          end
        end
      end
    end

    (0..31).each do |i|
      puts "#{i}, #{@list_of_states.count(i)}"
    end

    end_time=Time.new
    puts (end_time-start_time)*1000
  end

end

class GameState
  include Comparable
  attr_accessor :state_array
  attr_accessor :distance
  attr_accessor :path
  attr_accessor :estimated_distance
  def initialize
    @state_array=Array.new
    @distance=0
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

  def print_state
    puts
    puts @state_array[0].to_s + " " + @state_array[1].to_s + " " + @state_array[2].to_s
    puts @state_array[3].to_s + " " + @state_array[4].to_s + " " + @state_array[5].to_s
    puts @state_array[6].to_s + " " + @state_array[7].to_s + " " + @state_array[8].to_s
    puts
  end

#The empty tile (nine) goes up
  def up(position_of_empty_tile)
    @state_array[position_of_empty_tile]=@state_array[position_of_empty_tile-3]
    @state_array[position_of_empty_tile-3]=9
    @path+="D"
  end

#The empty tile (nine) goes down
  def down(position_of_empty_tile)
    @state_array[position_of_empty_tile]=@state_array[position_of_empty_tile+3]
    @state_array[position_of_empty_tile+3]=9
    @path+="U"
  end

#The empty tile (nine) goes right
  def right(position_of_empty_tile)
    @state_array[position_of_empty_tile]=@state_array[position_of_empty_tile+1]
    @state_array[position_of_empty_tile+1]=9
    @path+="L"
  end

#The empty tile (nine) goes left
  def left(position_of_empty_tile)
    @state_array[position_of_empty_tile]=@state_array[position_of_empty_tile-1]
    @state_array[position_of_empty_tile-1]=9
    @path+="R"
  end

  def get_neighbours
    neighbours=Array.new
    position_of_empty_tile=get_position_of_empty_tile

    if position_of_empty_tile>2 then
      neighbour_up=self.clone
      neighbour_up.up(position_of_empty_tile)
      neighbours<<neighbour_up
    end

    if position_of_empty_tile<6 then
      neighbour_down=self.clone
      neighbour_down.down(position_of_empty_tile)
      neighbours<<neighbour_down
    end

    if (position_of_empty_tile%3)!=0 then
      neighbour_left=self.clone
      neighbour_left.left(position_of_empty_tile)
      neighbours<<neighbour_left
    end

    if (position_of_empty_tile%3)!=2 then
      neighbour_right=self.clone
      neighbour_right.right(position_of_empty_tile)
      neighbours<<neighbour_right
    end

    return neighbours
  end

  def get_position_of_empty_tile
    @state_array.index(9)
  end

  def clone
    new_state=GameState.new
    new_state.state_array=@state_array.clone
    new_state.distance=@distance+1
    new_state.path=@path
    return new_state
  end

  def solved?
    return @state_array.eql?([1,2,3,4,5,6,7,8,9])
  end

  def solvable?
    return !parity
  end

  def parity
    transpozice=0;
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


a=[1,2,3,4,5,6,7,8,9]
counter=BFSCounter.new
counter.set_start_state
counter.solve
list=counter.list_of_states
#puts list[10]
h=ManhattanHeuristic.new
10.times do
  solver=BFSGameSolver.new
  solver.set_start_state(a.shuffle!)
  solver.start_state.print_state
  puts "Mělo by stačit #{list[solver.start_state.permutation_number]} kroků..."
  solver.solve
  solver=AStarGameSolver.new
  solver.set_start_state(a,h)
  solver.start_state.print_state
  puts "Mělo by stačit #{list[solver.start_state.permutation_number]} kroků..."
  puts "Heuristika: #{h.value(solver.start_state)}"
  solver.solve
end