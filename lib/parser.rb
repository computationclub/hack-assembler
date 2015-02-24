class Parser
  A_COMMAND = Object.new
  C_COMMAND = Object.new
  L_COMMAND = Object.new

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

  def symbol
    case command_type
    when A_COMMAND
      current[1..-1]
    else
      current[1..-2]
    end
  end

  def dest
    if current.include?('=')
      current.split('=').first
    else
      ''
    end
  end

  def comp
    current
      .split('=').last
      .split(';').first
  end

  def jump
    if current.include?(';')
      current.split(';').last
    else
      ''
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
