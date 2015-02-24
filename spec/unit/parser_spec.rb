require 'parser'

RSpec.describe Parser do
  MAX_PROGRAM = <<-eop
    // This file is part of www.nand2tetris.org
    // and the book "The Elements of Computing Systems"
    // by Nisan and Schocken, MIT Press.
    // File name: projects/06/max/Max.asm

    // Computes R2 = max(R0, R1)  (R0,R1,R2 refer to  RAM[0],RAM[1],RAM[2])

       @R0
       D=M              // D = first number
       @R1
       D=D-M            // D = first number - second number
       @OUTPUT_FIRST
       D;JGT            // if D>0 (first is greater) goto output_first
       @R1
       D=M              // D = second number
       @OUTPUT_D
       0;JMP            // goto output_d
    (OUTPUT_FIRST)
       @R0
       D=M              // D = first number
    (OUTPUT_D)
       @R2
       M=D              // M[2] = D (greatest number)
    (INFINITE_LOOP)
       @INFINITE_LOOP
       0;JMP            // infinite loop
  eop

  subject(:parser) { Parser.new(input) }

  describe '#has_more_commands?' do
    context 'when there are more commands in the input' do
      let(:input) { MAX_PROGRAM }

      it 'returns true' do
        expect(parser.has_more_commands?).to be_truthy
      end
    end

    context 'when there are no more commands in the input' do
      context 'because the input is empty' do
        let(:input) { '' }

        it 'returns false' do
          expect(parser.has_more_commands?).to be_falsy
        end
      end

      context 'because the input contains only whitespace' do
        let(:input) { "  \n  " }

        it 'returns false' do
          expect(parser.has_more_commands?).to be_falsy
        end
      end

      context 'because the input contains only comments' do
        let(:input) { '// a comment' }

        it 'returns false' do
          expect(parser.has_more_commands?).to be_falsy
        end
      end

      context 'because the input contains only whitespace and comments' do
        let(:input) { "  \n  // a comment\n  // another comment\n  " }

        it 'returns false' do
          expect(parser.has_more_commands?).to be_falsy
        end
      end
    end
  end

  describe '#advance' do
    let(:input) { MAX_PROGRAM }

    context 'when called fewer times than there are commands' do
      before(:example) do
        10.times do
          parser.advance
        end
      end

      it 'leaves more commands' do
        expect(parser.has_more_commands?).to be_truthy
      end
    end

    context 'when called as many times as there are commands' do
      before(:example) do
        19.times do
          parser.advance
        end
      end

      it 'leaves no more commands' do
        expect(parser.has_more_commands?).to be_falsy
      end
    end

    context 'with interleaved comments' do
      let(:input) do
        <<-eop
          @R0
          // An interleaved comment
          D=M
        eop
      end

      it 'leaves no more commands' do
        expect(parser.has_more_commands?).to be_truthy
        parser.advance
        expect(parser.has_more_commands?).to be_truthy
        parser.advance
        expect(parser.has_more_commands?).to be_falsy
      end
    end
  end

  describe '#command_type' do
    before(:example) do
      parser.advance
    end

    context 'when the current command is an A-instruction' do
      let(:input) { '@3' }

      it 'returns A_COMMAND' do
        expect(parser.command_type).to eq Parser::A_COMMAND
      end
    end

    context 'when the current command is a C-instruction' do
      let(:input) { 'D=D+A' }

      it 'returns C_COMMAND' do
        expect(parser.command_type).to eq Parser::C_COMMAND
      end
    end

    context 'when the current command is a label' do
      let(:input) { '(INFINITE_LOOP)' }

      it 'returns L_COMMAND' do
        expect(parser.command_type).to eq Parser::L_COMMAND
      end
    end
  end

  describe '#symbol' do
    before(:example) do
      parser.advance
    end

    context 'when the current command is an A-instruction' do
      context 'containing a symbol' do
        let(:input) { '@INFINITE_LOOP' }

        it 'returns the symbol' do
          expect(parser.symbol).to eq 'INFINITE_LOOP'
        end
      end

      context 'containing a decimal number' do
        let(:input) { '@42' }

        it 'returns the decimal number' do
          expect(parser.symbol).to eq '42'
        end
      end
    end

    context 'when the current command is a label' do
      let(:input) { '(INFINITE_LOOP)' }

      it 'returns the symbol' do
        expect(parser.symbol).to eq 'INFINITE_LOOP'
      end
    end
  end

  describe '#dest' do
    before(:example) do
      parser.advance
    end

    {
      'D;JLE'   => '',
      'M=D'     => 'M',
      'D=D+A'   => 'D',
      'MD=M-1'  => 'MD',
      'A=M'     => 'A',
      'AM=M+1'  => 'AM',
      'AD=A+1'  => 'AD',
      'AMD=M+1' => 'AMD'
    }.each do |command, mnemonic|
      context "when the dest mnemonic is #{mnemonic.empty? ? 'empty' : mnemonic}" do
        let(:input) { command }

        it "returns #{mnemonic.empty? ? 'the empty string' : mnemonic}" do
          expect(parser.dest).to eq mnemonic
        end
      end
    end
  end

  describe '#comp' do
    before(:example) do
      parser.advance
    end

    {
      '0;JMP'   => '0',
      'M=1'     => '1',
      'M=-1'    => '-1',
      'M=D'     => 'D',
      'D=A'     => 'A',
      'D=!D'    => '!D',
      'D=!A'    => '!A',
      'D=-D'    => '-D',
      'D=-A'    => '-A',
      'M=D+1'   => 'D+1',
      'AD=A+1'  => 'A+1',
      'AM=D-1'  => 'D-1',
      'A=A-1'   => 'A-1',
      'A=D+A'   => 'D+A',
      'A=D-A'   => 'D-A',
      'M=A-D'   => 'A-D',
      'M=D&A'   => 'D&A',
      'M=D|A'   => 'D|A',
      'D=M'     => 'M',
      'M=!M'    => '!M',
      'A=-M'    => '-M',
      'AM=M+1'  => 'M+1',
      'A=M-1'   => 'M-1',
      'M=D+M'   => 'D+M',
      'D=D-M'   => 'D-M',
      'M=M-D'   => 'M-D',
      'M=D&M'   => 'D&M',
      'M=D|M'   => 'D|M',
      'D=0;JMP' => '0'
    }.each do |command, mnemonic|
      context "when the comp mnemonic is #{mnemonic}" do
        let(:input) { command }

        it "returns #{mnemonic}" do
          expect(parser.comp).to eq mnemonic
        end
      end
    end
  end

  describe '#jump' do
    before(:example) do
      parser.advance
    end

    {
      'D=D+A'   => '',
      'D;JGT'   => 'JGT',
      'A;JEQ'   => 'JEQ',
      'A-1;JGE' => 'JGE',
      'M;JLT'   => 'JLT',
      '!D;JNE'  => 'JNE',
      'D+1;JLE' => 'JLE',
      '0;JMP'   => 'JMP'
    }.each do |command, mnemonic|
      context "when the jump mnemonic is #{mnemonic.empty? ? 'empty' : mnemonic}" do
        let(:input) { command }

        it "returns #{mnemonic.empty? ? 'the empty string' : mnemonic}" do
          expect(parser.jump).to eq mnemonic
        end
      end
    end
  end
end
