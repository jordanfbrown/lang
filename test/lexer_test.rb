require "test_helper"
require "lexer"

describe Lexer do
  let(:lexer) { described_class.new }
  
  describe "simple token parsing" do
    it "handles keywords" do
      Lexer::KEYWORDS.each do |keyword|
        expect(lexer.tokenize(keyword)).to eq([[keyword.upcase.to_sym, keyword]])
      end
    end

    it "handles other identifiers" do
      expect(lexer.tokenize("foo")).to eq([[:IDENTIFIER, "foo"]])
    end

    it "handles constants" do
      expect(lexer.tokenize("FOO")).to eq([[:CONSTANT, "FOO"]])
    end

    it "handles numbers" do
      expect(lexer.tokenize("1")).to eq([[:NUMBER, 1]])
    end

    it "handles strings" do
      expect(lexer.tokenize('"wow"')).to eq([[:STRING, "wow"]])
    end

    it "handles empty strings" do
      expect(lexer.tokenize('""')).to eq([[:STRING, ""]])
    end

    it "handles 2 space indentation" do
      expect(lexer.tokenize(":\n  ")).to eq([[:INDENT, 2], [:DEDENT, 0]])
    end

    it "handles 4 space indentation" do
      expect(lexer.tokenize(":\n    ")).to eq([[:INDENT, 4], [:DEDENT, 0]])
    end

    it "handles operators" do
      %w(|| && == != <= >=).each do |operator|
        expect(lexer.tokenize(operator)).to eq([[operator, operator]])
      end
    end

    it "doesn't return tokens for spaces" do
      expect(lexer.tokenize(" ")).to eq([])
    end

    it "handles single character operators" do
      %w(+ - % /).each do |operator|
        expect(lexer.tokenize(operator)).to eq([[operator, operator]])
      end
    end
  end
  
  describe "complex token parsing" do
    it "works" do
      code = <<-CODE
if foo:
  print "foo"
else:
  print "bar"
      CODE
      tokens = lexer.tokenize(code)
      expect(tokens).to eq([
        [:IF, "if"], [:IDENTIFIER, "foo"],
          [:INDENT, 2], [:IDENTIFIER, "print"], [:STRING, "foo"],
        [:DEDENT, 0], [:NEWLINE, "\n"], [:ELSE, "else"],
          [:INDENT, 2], [:IDENTIFIER, "print"], [:STRING, "bar"],
        [:DEDENT, 0]
       ])
    end
  end
end
