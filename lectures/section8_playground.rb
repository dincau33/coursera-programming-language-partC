class B

end

class A < B

  attr_accessor :foo
  Cons = 10
  @@bar = 0

  def initialize(f=[])
    super()
    @foo = [1,3,4]
  end

  def mapWrapper
    @foo.map { |x| yield x}
  end

end
