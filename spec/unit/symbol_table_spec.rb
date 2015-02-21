require 'symbol_table'

RSpec.describe SymbolTable do
  subject(:symbol_table) { SymbolTable.new }

  context 'when empty' do
    it 'doesn’t contain any symbols' do
      expect(symbol_table.contains?('SCREEN')).to be_falsy
      expect(symbol_table.contains?('KBD')).to be_falsy
    end
  end

  context 'when a symbol has been added' do
    before(:example) do
      symbol_table.add_entry('SCREEN', 0x4000)
    end

    it 'contains that symbol' do
      expect(symbol_table.contains?('SCREEN')).to be_truthy
    end

    it 'associates the correct address with that symbol' do
      expect(symbol_table.get_address('SCREEN')).to eq 0x4000
    end

    it 'doesn’t contain a different symbol' do
      expect(symbol_table.contains?('KBD')).to be_falsy
    end
  end
end
