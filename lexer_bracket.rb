class Lexer
  KEYWORDS = %w(def class if true false nil)

  def tokenize(code)
    code.chomp! # Remove extra line breaks
    tokens = []
    current_block = 0
    line_number = 1

    i = 0 # current char position
    while i < code.size
      chunk = code[i..-1]

      line_number += 1 if chunk.match(/\A\n/)

      if identifier = chunk[/\A([a-z]\w*)/, 1]
        if KEYWORDS.include?(identifier)
          tokens << [identifier.upcase.to_sym, identifier]
        else
          tokens << [:IDENTIFIER, identifier]
        end
        i += identifier.size
      elsif constant = chunk[/\A([A-Z]\w*)/, 1]
        tokens << [:CONSTANT, constant]
        i += constant.size
      elsif number = chunk[/\A([0-9]+)/, 1]
        tokens << [:NUMBER, number.to_i]
        i += number.size
      elsif string = chunk[/\A"([^"]*)"/, 1]
        tokens << [:STRING, string]
        i += string.size + 2
      elsif left_bracket = chunk[/\A(\{)\n/m, 1] # Matches "{<newline>"
        current_block += 1
        tokens << [:BLOCK_START, left_bracket]
        i += left_bracket.size
      elsif right_bracket = chunk[/\A(\})/m, 1] # Matches "}<newline>"
        if current_block == 0
          raise "Can't find opening block on line #{line_number}"
        else
          current_block -= 1
          tokens << [:BLOCK_END, right_bracket]
          i += right_bracket.size
        end
      elsif operator = chunk[/\A(\|\||&&|==|!=|<=|>=)/, 1]
        tokens << [operator, operator]
        i += operator.size
      elsif chunk.match(/\A\s/)
        i += 1
      else
        value = chunk[0,1]
        tokens << [value, value]
        i += 1
      end
    end

    tokens
  end
end

code = <<-CODE
if foo {
  1
}
}
else {
  2
}
CODE

puts code.inspect
tokens = Lexer.new.tokenize(code)
puts tokens.inspect
# Returns an array of tokens (a token being a tuple of [TOKEN_TYPE, TOKEN_VALUE])