module Code
  module_function

  def dest(mnemonic)
    ['A', 'D', 'M'].map { |dest| mnemonic.include?(dest) }.map { |bit| bit ? '1' : '0' }.join
  end

  def comp(mnemonic)
    m = mnemonic.include?('M')
    x = 'D'
    y = m ? 'M' : 'A'
    zx = !mnemonic.include?(x)
    zy = !mnemonic.include?(y)

    alu_function = mnemonic.tr([x, y].join, 'xy')

    nx, ny, f, no = {
      '0'   => '0010',
      '1'   => '1111',
      '-1'  => '1010',
      'x'   => '0100',
      'y'   => '1000',
      '!x'  => '0101',
      '!y'  => '1001',
      '-x'  => '0111',
      '-y'  => '1011',
      'x+1' => '1111',
      'y+1' => '1111',
      'x-1' => '0110',
      'y-1' => '1010',
      'x+y' => '0010',
      'x-y' => '1011',
      'y-x' => '0111',
      'x&y' => '0000',
      'x|y' => '1101'
    }[alu_function].chars.map { |c| c == '1' }

    [m, zx, nx, zy, ny, f, no].map { |bit| bit ? '1' : '0' }.join
  end

  def jump(mnemonic)
    %w[_ GT EQ GE LT NE LE MP].index(mnemonic.slice(1..-1) || '_').to_s(2).rjust(3, '0')
  end
end
