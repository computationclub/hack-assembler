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
            @current, _, @remaining = @remaining.partition("\n")
        end while @current =~ /^((\s*\/+.*)|\s*$)/
    end

    def command_type
        case @current.lstrip[0]
        when '@' then Parser::A_COMMAND
        when '(' then Parser::L_COMMAND
        else Parser::C_COMMAND
        end
    end

    def symbol
        case command_type
        when Parser::A_COMMAND then @current.strip[1..-1]
        when Parser::L_COMMAND then @current.strip[1..-2]
        else raise "Parser#symbol not defined for current command_type"
        end
    end
end
