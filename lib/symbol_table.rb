class SymbolTable
  def initialize
    @table = {}
  end

  def add_entry symbol, value
    @table[symbol] = value
  end

  def get_address symbol
    @table[symbol]
  end

  alias contains? get_address
end
