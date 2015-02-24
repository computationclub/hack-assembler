class Parser
  attr_reader :lines

  def initialize(input)
    input = input.gsub(%r{//.*$}, '').strip
    @lines = input.lines
  end

  def has_more_commands?
    !@lines.empty?
  end

  def advance
    @lines.shift
  end
end
