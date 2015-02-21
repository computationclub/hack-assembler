require 'strscan'

class Parser
  A_COMMAND, C_COMMAND, L_COMMAND = 3.times.map { Object.new }

  def initialize(input)
    self.scanner = StringScanner.new(input)
  end

  def has_more_commands?
    scanner.skip Patterns::WHITESPACE_AND_COMMENTS
    !scanner.eos?
  end

  attr_accessor :command_type, :symbol, :dest

  def advance
    scanner.skip Patterns::WHITESPACE_AND_COMMENTS

    if scanner.scan(Patterns::A_COMMAND)
      match = Patterns::A_COMMAND.match(scanner.matched)
      self.command_type = A_COMMAND
      self.symbol = match[:value]
    elsif scanner.scan(Patterns::C_COMMAND)
      match = Patterns::C_COMMAND.match(scanner.matched)
      self.command_type = C_COMMAND
      self.dest = match[:dest]
    elsif scanner.scan(Patterns::L_COMMAND)
      match = Patterns::L_COMMAND.match(scanner.matched)
      self.command_type = L_COMMAND
      self.symbol = match[:symbol]
    end
  end

  private

  attr_accessor :scanner

  module Patterns
    WHITESPACE_AND_COMMENTS =
      %r{
        (?: [[:space:]] | // .* $ )+
      }x

    CONSTANT =
      %r{
        [[:digit:]]+
      }x

    SYMBOL =
      %r{
        [ [[:alpha:]] _ . $ : ]
        [ [[:alnum:]] _ . $ : ]*
      }x

    VALUE = Regexp.union(CONSTANT, SYMBOL)

    A_COMMAND =
      %r{
        @
        (?<value> #{VALUE} )
      }x

    C_COMMAND =
      %r{
        (?:  (?<dest> [^ [[:space:]] ( ) = ; ]+)= | (?<dest>) )  # dest field, optional, “=”-suffixed
        (?:  (?<comp> [^ [[:space:]] ( ) = ; ]+)              )  # comp field, required
        (?: ;(?<jump> [^ [[:space:]] ( ) = ; ]+)  | (?<jump>) )  # jump field, optional, “;”-prefixed
      }x

    L_COMMAND =
      %r{
        \(
        (?<symbol> #{SYMBOL} )
        \)
      }x
  end
end
