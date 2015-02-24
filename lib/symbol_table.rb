class SymbolTable
  def initialize
    @table = {}
  end

  def contains?(sym)
    @table.has_key? sym
  end

  def add_entry(sym, address)
    @table[sym] = address
  end

  def get_address(sym)
    @table.fetch(sym)
  end
end
