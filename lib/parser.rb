class Parser
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
end
