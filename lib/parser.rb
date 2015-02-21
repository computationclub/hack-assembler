class Parser
  def initialize(input)
    self.more_commands =
      input.lines.
        map { |line| line.sub(%r{//.*}, '') }.
        map(&:strip).
        reject(&:empty?)
  end

  def has_more_commands?
    more_commands.any?
  end

  private

  attr_accessor :more_commands
end
