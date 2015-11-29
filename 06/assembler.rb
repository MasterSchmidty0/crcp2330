#! /usr/bin/env ruby

asm_filename = ARGV[0]

puts asm_filename

if (ARGV[0] && ARGV[0].end_with?(".asm") && ARGV.length == 1)
  puts ARGV[0]
end

#and the argument ends in .asm
#then we're good.