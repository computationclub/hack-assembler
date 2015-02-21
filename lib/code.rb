module Code
  module_function

  def dest(mnemonic)
    ['A', 'D', 'M'].map { |dest| mnemonic.include?(dest) }.map { |bit| bit ? '1' : '0' }.join
  end
end
