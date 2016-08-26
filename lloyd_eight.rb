require 'pry'
require_relative 'heuristics'
require_relative 'priority_queue'
require_relative 'GameState'
require_relative 'factorial'
require_relative 'BFSSolver'
require_relative 'Counter'
require_relative 'AStarSolver'

class AStarGameSolver
  attr_accessor :list_of_states
  attr_accessor :q
  attr_accessor :start_state
  attr_accessor :heuristic


  def set_start_state(array,h)
    @start_state=GameState.new
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

a=(1..9).to_a

#counter=Counter.new
#counter.set_start_state
#counter.solve
#counter.solve(7,1,true)
#list=counter.list_of_states
# puts list[10]
# h=ManhattanHeuristic.new
# state = GameState.new(3,3,a.clone)
solver = BFSSolver.new
GameState.set_dimensions(3, 3)
10.times do 
  solver.solve(3,3,[1,2,3,4,5,6,7,9,8])
end
#state.print_state

#state = GameState.new(4,3,(1..12).to_a)
#state.print_state

#state = GameState.new(3,4,(1..12).to_a)
#state.print_state


#  solver=BFSGameSolver.new
#  solver.set_start_state(4,4,(1..16).to_a)
#  solver.start_state.random_move!(10)
#  solver.start_state.print_state
#  puts "Mělo by stačit #{list[solver.start_state.permutation_number]} kroků..."
#  solver.solve
#  solver=AStarGameSolver.new
#  solver.set_start_state(a,h)
#  solver.start_state.print_state
#  puts "Mělo by stačit #{list[solver.start_state.permutation_number]} kroků..."
#  puts "Heuristika: #{h.value(solver.start_state)}"
#  solver.solve
