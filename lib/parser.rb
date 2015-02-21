require 'strscan'

class Parser
  def initialize(input)
    self.scanner = StringScanner.new(input)
  end

  def has_more_commands?
    scanner.skip Patterns::WHITESPACE_AND_COMMENTS
    !scanner.eos?
  end

  def advance
    scanner.skip Patterns::WHITESPACE_AND_COMMENTS
    scanner.skip(Patterns::A_COMMAND) || scanner.skip(Patterns::C_COMMAND) || scanner.skip(Patterns::L_COMMAND)
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
