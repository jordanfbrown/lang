require "spec_helper"
require "parser"

describe Parser do
  let(:parser) { described_class.new }

  it "handles numbers" do
    expect(parser.parse("1")).to eq(Nodes.new([NumberNode.new(1)]))
  end

  it "handles a call to an identifier without an argument" do
    expect(parser.parse("foo.bar")).to eq(Nodes.new([CallNode.new(GetLocalNode.new("foo"), "bar", [])]))
  end

  it "handles a call to an identifier with an argument" do
    expect(parser.parse("foo.bar(baz)")).to eq(Nodes.new([CallNode.new(GetLocalNode.new("foo"), "bar", [GetLocalNode.new("baz")])]))

  end

  it "handles a call to a number without an argument" do
    expect(parser.parse("1.bar")).to eq(Nodes.new([CallNode.new(NumberNode.new(1), "bar", [])]))
  end

  it "handles assignment" do
    expect(parser.parse("a = 1")).to eq(Nodes.new([SetLocalNode.new("a", NumberNode.new(1))]))
    expect(parser.parse("A = 1")).to eq(Nodes.new([SetConstantNode.new("A", NumberNode.new(1))]))
  end
end