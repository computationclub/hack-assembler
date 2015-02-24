class Parser
  A_COMMAND = :a_command
  C_COMMAND = :c_command
  L_COMMAND = :l_command

  def initialize(input)
    @input = input.lines

    strip_whitespace
    strip_comments
  end

  def has_more_commands?
    @input.length > 0
  end

  def advance
    @current_command = @input.shift
  end

  def command_type
    case @current_command
    when /^@/
      A_COMMAND
    when /^\(/
      L_COMMAND
    else
      C_COMMAND
    end
  end

  def symbol
    case command_type
    when A_COMMAND
      @current_command.gsub('@','')
    when L_COMMAND
      @current_command.match(/\((.*)\)/)[1]
    end
  end

  def dest
    if @current_command.include?("=")
      tokens = @current_command.split("=")
      tokens.first
    else
      ''
    end
  end

  def comp
    if @current_command.include?("=")
      tokens = @current_command.split("=")
      tokens.last
    else
      @current_command.split(";").first
    end
  end

  def jump
    if @current_command.include?(";")
      tokens = @current_command.split(";")
      tokens.last
    else
      ''
    end
  end


  private
  def strip_whitespace
    @input =
      @input.map { |line| line.strip }.reject { |line| line.empty? }
  end

  def strip_comments
    @input =
      @input.reject { |line| line =~ /^\/\// }
  end
end
