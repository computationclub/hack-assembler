module Code
    def self.dest mnemonic
        d1 = mnemonic.index('A') ? '1' : '0'
        d2 = mnemonic.index('D') ? '1' : '0'
        d3 = mnemonic.index('M') ? '1' : '0'
        d1 + d2 + d3
    end
end
