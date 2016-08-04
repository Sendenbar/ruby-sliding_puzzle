require 'set'

class BFSGameSolver
  attr_accessor :list_of_states
  attr_accessor :q
  attr_accessor :start_state


  def set_start_state(rows,columns,array)
    @start_state=GameState.new(rows,columns,array.clone) 
    @start_state.path=""
  end

  def solve
   
    start_time=Time.new
    
    if @start_state.solvable? then
      # Should probably use sortedset....
      list_of_states = Set.new()
      q = Queue.new
      q.push(@start_state)
      @counter = 0
      @current_state = @start_state
      while (!q.empty? && !@current_state.solved?) do
        @current_state = q.pop
        @counter += 1
        @current_state.get_neighbours.each do |neighbour|
          if neighbour.solved? then
            @solved = true
            @current_state = neighbour
          end
          unless list_of_states.include?(neighbour.permutation_number)
            q.push(neighbour)
            list_of_states << neighbour.permutation_number
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
