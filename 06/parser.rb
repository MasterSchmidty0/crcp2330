require_relative 'code'

class Parser

	SYMBOLS = {
		'SP' => '0',
		'LCL' => '1',
		'ARG' => '2',
		'THIS' => '3',
		'THAT' => '4',
		'R0' => '0',
		'R1' => '1',
		'R2' => '2',
		'R3' => '3',
		'R4' => '4',
		'R5' => '5',
		'R6' => '6',
		'R7' => '7',
		'R8' => '8',
		'R9' => '9',
		'R10' => '10',
		'R11' => '11',
		'R12' => '12',
		'R13' => '13',
		'R14' => '15',
		'R16' => '16',
		'SCREEN' => '16384',
		'KBD' => '24576'
	}

	def initialize(assembly_instructions)
		@assembly_instructions = assembly_instructions
		@code = Code.new()
		@machine_instructions = []
	end

	def parse

		# First pass
		instruction_address = 0
		@assembly_instructions.each do |instruction|
			if command_type(instruction) == :l_command
				part_1 = instruction.chomp(')')
				label = part_1[1..-1]
				SYMBOLS["#{label}"] = "#{instruction_address}"
			else
				instruction_address += 1
			end
		end

		# Second pass
		variable_counter = 16
		@assembly_instructions.each do |instruction|
			if command_type(instruction) == :a_command
				variable = instruction[1..-1]
				if SYMBOLS.has_key?(variable)
					@machine_instructions << assemble_a_command(symbol(variable))
				else
					SYMBOLS["#{variable}"] = variable_counter
					@machine_instructions << assemble_a_command(symbol(variable))
					variable_counter += 1
				end
			elsif command_type(instruction) == :c_command
				@machine_instructions << assemble_c_command(instruction)
			end
		end
		@machine_instructions
	end

	def assemble_a_command(address)
		command = "0"
		command << constant(address)
	end

	def constant(value)
		"%015b" % value
	end

	def assemble_c_command(instruction)
			command = "111"
			if comp!(instruction).include?('M')
				command << "1"
			else
				command << "0"
			end
			command << @code.comp(comp!(instruction))
			command << @code.dest(dest!(instruction))
			command << @code.jump(jump!(instruction))
	end

	def command_type(instruction)
		if instruction.start_with?("(")
			:l_command
		elsif instruction.start_with?("@")
			:a_command
		else
			:c_command
		end
	end

	def dest!(c_command)
		if c_command.include?('=')
			dest_part = c_command.split('=')[0]
		else
			dest_part = nil
		end
	end

	def comp!(c_command)
		if c_command.include?('=')
			part_1 = c_command.split('=')[1]
			comp_part = part_1.split(';')[0]
		else
			comp_part = c_command.split(';')[0]
		end
	end

	def jump!(c_command)
		jump_part = c_command.split(';')[1]
	end

	def symbol(instruction)
		SYMBOLS[instruction]
	end

end