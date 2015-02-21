require 'forwardable'

class SymbolTable
  def initialize
    self.contents = {}
  end

  extend Forwardable

  def_delegator :contents, :[]=, :add_entry
  def_delegator :contents, :has_key?, :contains?
  def_delegator :contents, :[], :get_address

  private

  attr_accessor :contents
end
