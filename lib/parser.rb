require 'treetop'
Treetop.load(File.expand_path('../hack', __FILE__))

class Parser
  A_COMMAND, C_COMMAND, L_COMMAND = 3.times.map { Object.new }

  def initialize(input)
    self.commands = HackParser.new.parse(input).commands
  end

  def has_more_commands?
    commands.any?
  end

  attr_accessor :command_type, :symbol, :dest, :comp, :jump

  def advance
    command = commands.shift

    case command[:type]
    when :a
      self.command_type = A_COMMAND
      self.symbol = command[:value]
    when :c
      self.command_type = C_COMMAND
      self.dest = command[:dest]
      self.comp = command[:comp]
      self.jump = command[:jump]
    when :l
      self.command_type = L_COMMAND
      self.symbol = command[:symbol]
    end
  end

  private

  attr_accessor :commands
end
