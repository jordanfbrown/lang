require "spec_helper"
require "interpreter"

describe Interpreter do
  specify "it works!" do
    code = <<-CODE
class Awesome:
  def test:
    "yup"

awesome = Awesome.new
if awesome:
  print(awesome.test)
CODE

    expect { Interpreter.new.eval(code) }.to output("yup\n").to_stdout
  end
end