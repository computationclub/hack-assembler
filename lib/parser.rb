require 'strscan'

class Parser
  def initialize(input)
    self.scanner = StringScanner.new(input)
  end

  def has_more_commands?
    scanner.skip Patterns::WHITESPACE_AND_COMMENTS
    !scanner.eos?
  end

  private

  attr_accessor :scanner

  module Patterns
    WHITESPACE_AND_COMMENTS =
      %r{
        (?: [[:space:]] | // .* $ )+
      }x
  end
end
