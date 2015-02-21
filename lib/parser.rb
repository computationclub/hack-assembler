class Parser
  A_COMMAND, C_COMMAND, L_COMMAND = 3.times.map { Object.new }

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
    self.current_command, *self.more_commands = more_commands
  end

  def command_type
    if current_command.start_with?('@')
      A_COMMAND
    elsif current_command.start_with?('(')
      L_COMMAND
    else
      C_COMMAND
    end
  end

  def symbol
    if current_command.start_with?('@')
      current_command.slice(1..-1)
    elsif current_command.start_with?('(')
      current_command.slice(1..-2)
    end
  end

  private

  attr_accessor :current_command, :more_commands
end
