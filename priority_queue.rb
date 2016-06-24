class PriorityQueue
  attr_accessor :heap

  def initialize 
    @heap = []
  end
  
  def clear
    @heap.clear
  end

  def enqueue(element)
    if @heap == [] then
      @heap << element
    else
      @heap << element
      heapup(@heap.size - 1)
    end
  end

  def dequeue
    value = @heap[0]
    @heap[0] = @heap[-1]
    @heap.pop
    heapdown(0) if @heap.size > 1
    return value
  end

  def heapup(index)
    unless index == 0 then
      parent = index_of_parent(index)
      if @heap[index] < @heap[parent]
        @heap[index], @heap[parent] = @heap[parent], @heap[index]
        heapup(parent)
      end
    end
  end


  def heapdown(index)
    if @heap.size - 1 > 2 * index then
      son = index_of_smaller_son(index)
      if @heap[index] > @heap[son] then
        @heap[index], @heap[son] = @heap[son], @heap[index]
        heapdown(son)
      end
    end
  end

  def index_of_smaller_son(index)
    if @heap.size - 1 < 2 * index + 2 then
      return 2 * index + 1
    else
      return @heap[2 * index + 1] < @heap[2 * index + 2] ? 2 * index + 1 : 2 * index + 2
    end
  end

  def index_of_parent(index)
    (index - 1) / 2 if index > 0
  end

  def empty?
    @heap.empty?
  end
end
