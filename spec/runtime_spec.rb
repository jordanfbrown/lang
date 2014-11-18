require "spec_helper"
require "runtime"

describe "Runtime" do
  it "sets the Object constant" do
    expect(Constants["Object"]).to be_instance_of(AwesomeClass)
  end

  it "creates objects" do
    expect(Constants["Object"].new.runtime_class).to eq(Constants["Object"])
  end

  it "creates numbers" do
    expect(Constants["Number"].new_with_value(32).ruby_value).to eq(32)
  end

  it "can lookup a method" do
    expect(Constants["Object"].lookup("print")).to be_instance_of(Proc)
  end

  it "raises a RuntimeError if the method doesn't exist" do
    expect { Constants["Object"].lookup("foo") }.to raise_error(RuntimeError)
  end

  it "can call methods" do
    object = Constants["Object"].call("new")
    expect(object.runtime_class).to eq(Constants["Object"])

    number = Constants["Number"].call("new")
    expect(number.runtime_class).to eq(Constants["Number"])
  end

  specify "a class is a class" do
    expect(Constants["Number"].runtime_class).to eq(Constants["Class"])
  end

  specify "numbers can be added" do
    x = Constants["Number"].new_with_value(2)
    y = Constants["Number"].new_with_value(3)
    result = x.call("+", [y])
    expect(result.runtime_class).to eq(Constants["Number"])
    expect(result.ruby_value).to eq(5)
  end

  specify "inheritance works" do
    number = Constants["Number"].new_with_value(3)
    result = number.call("inspect")
    expect(result.runtime_class).to eq(Constants["Number"])
  end
end
