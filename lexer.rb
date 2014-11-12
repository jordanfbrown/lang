class Lexer
  KEYWORDS = %w(def class if true false else nil)

  def tokenize(code)
    code.chomp! # Remove extra line breaks
    tokens = []
    current_indent = 0
    indent_stack = []

    i = 0 # current char position
    while i < code.size
      chunk = code[i..-1]
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
      elsif indent = chunk[/\A\:\n(\s+)/m, 1] # Matches ": <newline> <spaces>"
        if indent.size < current_indent
          raise "Bad indent level, got #{indent.size} indents, expected > #{current_indent}"
        end
        current_indent = indent.size
        indent_stack.push(current_indent)
        tokens << [:INDENT, indent.size]
        i += indent.size + 2
      elsif indent = chunk[/\A\n(\s*)/m, 1] # Matches "<newline> <spaces>"
        if indent.size == current_indent
          tokens << [:NEWLINE, "\n"] # No op, we're in the same block
        elsif indent.size < current_indent
          while indent.size < current_indent
            indent_stack.pop
            current_indent = indent_stack.last || 0
            tokens << [:DEDENT, indent.size]
          end
          tokens << [:NEWLINE, "\n"]
        else # indent.size > current_indent -- error!
          raise "Missing :" # Can't increase indent level without using ":"
        end
        i += indent.size + 1
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

    while indent_stack.pop
      tokens << [:DEDENT, indent_stack.first || 0]
    end

    tokens
  end
end
