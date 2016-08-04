class Fixnum
  def factorial
    (2..self).reduce(:*) || 1
  end
end
