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

    def self.comp mnemonic
        address = mnemonic.index('M') ? '1' : '0'

        # Swap M for A so the lookup table doesn't need to account for both
        comp = case mnemonic.sub('M', 'A')
        when "0"   then '101010'
        when '0'   then '101010'
        when '1'   then '111111'
        when '-1'  then '111010'
        when 'D'   then '001100'
        when 'A'   then '110000'
        when '!D'  then '001101'
        when '!A'  then '110001'
        when '-D'  then '001111'
        when '-A'  then '110011'
        when 'D+1' then '011111'
        when 'A+1' then '110111'
        when 'D-1' then '001110'
        when 'A-1' then '110010'
        when 'D+A' then '000010'
        when 'D-A' then '010011'
        when 'A-D' then '000111'
        when 'D&A' then '000000'
        when 'D|A' then '010101'
        else raise "Unknown mnemonic"
        end

        address + comp
    end
end
