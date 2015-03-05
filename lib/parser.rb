class Parser
    def initialize input
        @remaining = input
    end

    def has_more_commands?
        @remaining =~ /^\s*[^\s\/]+.*$/
    end
end
