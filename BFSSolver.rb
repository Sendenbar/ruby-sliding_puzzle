require 'set'
require 'pry'
class BFSSolver
  attr_accessor :list_of_states
  attr_accessor :q
  attr_accessor :start_state
  attr_accessor :end_state

  def solve(rows, columns, array)
    GameState.set_dimensions(rows, columns)
    @counter = 1 
    @start_state = GameState.new(array.clone) 
    @start_state.path=""
   
    start_time = Time.new
    
    if @start_state.solvable? then
      list_of_states = Set.new()
      q = Queue.new
      @current_state = @start_state
      q << @current_state
      @solved = false
       
      while (!q.empty? && !@current_state.solved?) do
        @current_state = q.pop
        @counter += 1
        
        @current_state.get_neighbours.each do |neighbour|
          if neighbour.solved? then
            @counter += 1
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

      @end_state = @current_state
      @time_needed = Time.new - start_time 
      print_output
    else
      puts "Impossible state."
    end
  end


  def print_output
    puts @end_state
    puts "#{@end_state.distance} steps needed."
    puts @end_state.path
    puts "#{@counter} states visited."
    puts "Path found in #{@time_needed} seconds."
  end

end
