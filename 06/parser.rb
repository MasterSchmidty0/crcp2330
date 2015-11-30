require_relative 'code'

class Parser

	def initialize(assembly_instructions)
		@assembly_instructions = assembly_instructions
		@code = Code.new()
		@machine_instructions = []
	end

	def parse
		@assembly_instructions.each do |instruction|
			if command_type(instruction) == :a_command
				@machine_instructions << assemble_a_command(instruction)
			elsif command_type(instruction) == :c_command
				@machine_instructions << assemble_c_command(instruction)
			end
		end
		@machine_instructions
	end

	def assemble_a_command(instruction)
		command = "0"
		command << constant(instruction[1..-1])
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
		if instruction.start_with?("@")
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

end