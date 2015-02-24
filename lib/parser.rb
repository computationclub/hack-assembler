class Parser
  def initialize(input)
    @lines = split_lines(input)
  end

  def has_more_commands?
    !lines.empty?
  end

  def advance
    lines.shift
  end

  private

  attr_reader :lines

  def split_lines(input)
    input
      .lines
      .map { |line| line.sub(%r{//.*$}, '').strip }
      .reject(&:empty?)
  end
end
