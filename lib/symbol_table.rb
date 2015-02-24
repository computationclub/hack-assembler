class SymbolTable
  def initialize
    @symbols = Hash.new
  end

  def contains?(symbol)
    symbols.key?(symbol)
  end

  def add_entry(symbol, address)
    symbols[symbol] = address
  end

  def get_address(symbol)
    symbols.fetch(symbol)
  end

  private

  attr_reader :symbols
end
