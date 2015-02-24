class Parser
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def has_more_commands?
    !input.gsub(%r{//.*$}, '').strip.empty?
  end
end
