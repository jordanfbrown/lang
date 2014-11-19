class AwesomeClass < AwesomeObject
  attr_reader :runtime_methods

  def initialize(super_class = nil)
    @runtime_methods = {}
    @runtime_class = Constants["Class"]
    @runtime_superclass = super_class
  end

  def lookup(method_name)
    method = @runtime_methods[method_name]
    unless method
      if @runtime_superclass
        return @runtime_superclass.lookup(method_name)
      else
        raise "Method `#{method_name}` not found on class "
      end
    end
    method
  end

  def def(name, &block)
    @runtime_methods[name.to_s] = block
  end

  def new
    AwesomeObject.new(self)
  end

  def new_with_value(value)
    AwesomeObject.new(self, value)
  end
end