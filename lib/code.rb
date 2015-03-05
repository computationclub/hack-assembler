module Code
    def self.dest mnemonic
        d1 = mnemonic.index('A') ? '1' : '0'
        d2 = mnemonic.index('D') ? '1' : '0'
        d3 = mnemonic.index('M') ? '1' : '0'
        d1 + d2 + d3
    end

    def self.jump mnemonic
        return "111" if mnemonic == "JMP"
        return "101" if mnemonic == "JNE"
        j1 = mnemonic.index('L') ? '1' : '0'
        j2 = mnemonic.index('E') ? '1' : '0'
        j3 = mnemonic.index('G') ? '1' : '0'
        j1 + j2 + j3
    end
end
