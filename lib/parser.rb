class Parser
    A_COMMAND = 4
    L_COMMAND = 1
    C_COMMAND = 8

    def initialize input
        @remaining = input
    end

    def has_more_commands?
        @remaining =~ /^\s*[^\s\/]+.*$/
    end

    def advance
        begin
            line, _, @remaining = @remaining.partition("\n")
            # Strip trailing comments
            @current = line.partition('//').first.strip
        end while @current.empty?
    end

    def command_type
        case @current.lstrip[0]
        when '@' then Parser::A_COMMAND
        when '(' then Parser::L_COMMAND
        else Parser::C_COMMAND
        end
    end

    def each_command
        while has_more_commands?
            advance
            yield command_type
        end
    end

    def symbol
        case command_type
        when Parser::A_COMMAND then @current.strip[1..-1]
        when Parser::L_COMMAND then @current.strip[1..-2]
        else wrong_command_type
        end
    end

    def dest
        wrong_command_type unless command_type == Parser::C_COMMAND

        dest, match, _ = @current.partition('=')
        match.empty? ? "" : dest
    end

    def jump
        wrong_command_type unless command_type == Parser::C_COMMAND

        _, match, jump = @current.rpartition(';')
        match.empty? ? "": jump
    end

    def comp
        wrong_command_type unless command_type == Parser::C_COMMAND

        comp, _, _ = @current.partition(';')
        comp.rpartition('=')[2]
    end

    private
    def wrong_command_type
        f = caller[0][/`.*'/][1..-2]
        raise "#{self.class}##{f} not defined for current command_type"
    end
end
