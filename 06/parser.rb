class Parser

	def initialize(assembly_instructions)
		@assembly_instructions = assembly_instructions
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
	end

	def command_type(instruction)
		if instruction.start_with?("@")
			:a_command
		else
			:c_command
		end
	end


end