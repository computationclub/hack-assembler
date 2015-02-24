class Parser
  class A_COMMAND; end
  class C_COMMAND; end
  class L_COMMAND; end

  def initialize(input)
    @lines = split_lines(input)
  end

  def has_more_commands?
    !lines.empty?
  end

  def advance
    @current = lines.shift
  end

  def command_type
    if current.start_with?('@')
      A_COMMAND
    elsif current.start_with?('(')
      L_COMMAND
    else
      C_COMMAND
    end
  end

  private

  attr_reader :lines, :current

  def split_lines(input)
    input
      .lines
      .map { |line| line.sub(%r{//.*$}, '').strip }
      .reject(&:empty?)
  end
end
