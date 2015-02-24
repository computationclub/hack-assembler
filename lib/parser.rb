require 'strscan'

class Scanner
  TOKENS = {
    whitespace_and_comments: %r{ (?: [[:space:]] | // .* $)+ }x,
    number: %r{ [[:digit:]]+ }x,
    identifier: %r{ [[[:alpha:]]_.$:] [[[:alnum:]]_.$:]* }x,
    operation: %r{ [!+\-&|] }x,
    at: %r{ @ }x,
    left_bracket: %r{ \( }x,
    right_bracket: %r{ \) }x,
    equals: %r{ = }x,
    semicolon: %r{ ; }x
  }

  def initialize(input)
    self.input = StringScanner.new(input)
  end

  def each_token
    until input.eos?
      TOKENS.each do |type, pattern|
        if string = input.scan(pattern)
          yield type, string
          break
        end
      end
    end
  end

  def tokens
    to_enum :each_token
  end

  private

  attr_accessor :input
end

class Parser
  A_COMMAND, C_COMMAND, L_COMMAND = 3.times.map { Object.new }

  def initialize(input)
    self.tokens = Scanner.new(input).tokens
  end

  def has_more_commands?
    begin
      loop do
        type, string = tokens.peek
        return true unless type == :whitespace_and_comments
        tokens.next
      end
    rescue StopIteration
      false
    end
  end

  attr_accessor :command_type, :symbol, :dest, :comp, :jump

  def read_field
    field = ''

    type, string = tokens.next
    begin
      while [:identifier, :number, :operation].include?(type)
        field << string
        type, string = tokens.next
      end
    rescue StopIteration
      type = :whitespace_and_comments
    end

    [field, type]
  end

  def advance
    begin
      loop do
        type, string = tokens.peek
        break unless type == :whitespace_and_comments
        tokens.next
      end
    rescue StopIteration
    end

    type, string = tokens.peek

    case type
    when :at
      self.command_type = A_COMMAND
      tokens.next
      _, self.symbol = tokens.next
    when :identifier, :number, :operation
      self.command_type = C_COMMAND
      fields = []
      separators = []

      loop do
        field, separator = read_field

        fields << field
        break if separator == :whitespace_and_comments
        separators << separator
      end

      self.dest, self.comp, self.jump =
        case separators
        when [:equals]
          [*fields, '']
        when [:semicolon]
          ['', *fields]
        when [:equals, :semicolon]
          fields
        end
    when :left_bracket
      self.command_type = L_COMMAND
      tokens.next
      _, self.symbol = tokens.next
      tokens.next
    end
  end

  private

  attr_accessor :tokens
end
