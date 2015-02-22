# Hack assembler

[![Build Status](https://travis-ci.org/computationclub/hack-assembler.svg?branch=master)](https://travis-ci.org/computationclub/hack-assembler)

This is a Ruby implementation of an assembler for the Hack machine language. The language itself is described in [chapter four](http://nand2tetris.org/chapters/chapter%2004.pdf) of “[The Elements of Computing Systems](http://nand2tetris.org/)”; this assembler conforms to the design described in [chapter six](http://nand2tetris.org/chapters/chapter%2006.pdf).

## Running

The assembler is at `bin/assembler`. It reads a symbolic assembly program from the file named in its first argument (or from standard input if no argument is provided); in slight defiance of the book, it then writes a binary version of that program to standard output rather than directly to a file.

For example:

```
$ git clone https://github.com/computationclub/hack-assembler
$ cd hack-assembler
$ ./bin/assembler spec/acceptance/examples/Max.asm
0000000000000000
1111110000010000
0000000000000001
1111010011010000
0000000000001010
1110001100000001
0000000000000001
1111110000010000
0000000000001100
1110101010000111
0000000000000000
1111110000010000
0000000000000010
1110001100001000
0000000000001110
1110101010000111
```

## Testing

Both unit and acceptance tests are provided.

The unit tests verify that each module (`Parser`, `Code` and `SymbolTable`) implements the API described in chapter six. To run them, use `bundle exec rspec spec/unit`.

The acceptance tests run `bin/assembler` against each [example Hack program](spec/acceptance/examples) and compare its output against that of the [reference implementation](http://nand2tetris.org/software.php). To run them, use `bundle exec rspec spec/acceptance`. This takes more time than running the unit tests.

To run all of the tests, use `bundle exec rspec`.
