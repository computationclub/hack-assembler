RSpec.describe 'the assembler' do
  ASSEMBLER_PATH = File.expand_path('../../../bin/assembler', __FILE__)
  EXAMPLES_PATH = File.expand_path('../examples', __FILE__)
  INPUT_EXT = '.asm'
  OUTPUT_EXT = '.hack'

  input_filenames = Dir.glob(File.join(EXAMPLES_PATH, '*' + INPUT_EXT))
  output_filenames = input_filenames.map { |name| File.join(File.dirname(name), File.basename(name, INPUT_EXT) + OUTPUT_EXT) }

  input_filenames.zip(output_filenames) do |input_filename, output_filename|
    machine_code = File.read(output_filename)

    it "assembles #{File.basename(input_filename)} into #{File.basename(output_filename)}" do
      expect { system(ASSEMBLER_PATH, input_filename) || raise }.to output(machine_code).to_stdout_from_any_process
    end
  end
end
