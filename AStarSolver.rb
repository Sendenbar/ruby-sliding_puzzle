class AStarSolver
  attr_accessor :list_of_states
  attr_accessor :q
  attr_accessor :start_state
  attr_accessor :heuristic
  attr_accessor :end_state

  def set_start_state(array,h)
    @start_state=GameState.new
    @start_state.state_array = array
    @start_state.path=""
    @heuristic=h
  end

  def solve_old(rows, columns, array, heuristic)
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


  def solve(rows, columns, array, heuristic)

    GameState.set_dimensions(rows, columns,)
    GameState.set_heuristic(heuristic)
    @counter = 1 
    @start_state = GameState.new(array.clone) 
    @start_state.path=""

    start_time = Time.new
    
    if @start_state.solvable? then
      list_of_states = Set.new()
      q = PriorityQueue.new
      @current_state = @start_state
      q.enqueue(@current_state)
      @solved = false
       
      while (!q.empty? && !@current_state.solved?) do
        @current_state = q.dequeue
        @counter += 1
        
        @current_state.get_neighbours.each do |neighbour|
          if neighbour.solved? then
            @counter += 1
            @solved = true
            @current_state = neighbour
          end
          unless list_of_states.include?(neighbour.permutation_number)
            q.enqueue(neighbour)
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

 def solve_refactoring(rows, columns, array, heuristic)
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

  def print_output_old
    puts "Stačí #{@current_state.distance} kroků."
    puts @current_state.path
    puts "Algoritmus prošel #{@counter} vrcholy."
  end
  def print_output
    puts @end_state
    puts "#{@end_state.distance} steps needed."
    puts @end_state.path
    puts "#{@counter} states visited."
    puts "Path found in #{@time_needed} seconds."
  end


end


