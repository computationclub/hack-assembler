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

  def advance
    _, *self.more_commands = more_commands
  end

  private

  attr_accessor :more_commands
end
