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

  it "handles def with no arguments" do
    code = <<-CODE
      def method:
        true
    CODE
    expect(parser.parse(code)).to eq(Nodes.new([
      DefNode.new("method", [], Nodes.new([TrueNode.new]))
    ]))
  end

  it "handles !" do
    expect(parser.parse("!2")).to eq(Nodes.new([
      CallNode.new(NumberNode.new(2), "!", [])
    ]))
  end

  it "handles def with arguments" do
    code = <<-CODE
      def method(a, b):
        true
    CODE
    expect(parser.parse(code)).to eq(Nodes.new([
      DefNode.new("method", ["a", "b"], Nodes.new([TrueNode.new]))
    ]))
  end

  it "handles while" do
    code = <<-CODE
      while true:
        true
    CODE
    expect(parser.parse(code)).to eq(Nodes.new([
      WhileNode.new(TrueNode.new, Nodes.new([TrueNode.new]))
    ]))
  end


end