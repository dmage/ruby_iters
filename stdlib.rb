require 'core'

class TextFile < Source
	def initialize(filename)
		super()
		@filename = filename
		@f = File.open(@filename, "r")
	end

	def run
		if select([@f], [], [], 0.1)
			line = @f.gets
			self.send(0, line)
		end
	end
end

class Timer < Source
	def initialize(minimal_delay)
		super()
		@minimal_delay = minimal_delay
		@last_fire = nil
	end

	def run
		now = Time.now.to_f
		if @last_fire.nil? || (now - @last_fire >= @minimal_delay)
			@last_fire = now
			self.send(0, now)
		end
	end
end

class DisplayIterator < UnaryIterator
	def evaluate(inputs)
		value = inputs[0]
		puts("#{value}")
		return value
	end
end

def display(iter)
	x = DisplayIterator.new()
	iter.connect(x, 0)
	return x
end

class ExtractIterator < UnaryIterator
	def initialize(regexp)
		super()
		@regexp = regexp
	end

	def evaluate(inputs)
		value = inputs[0]
		match = @regexp.match(value)
		if !match.nil?
			return match[1]
		end
		return nil
	end
end

def extract(iter, regexp)
	x = ExtractIterator.new(regexp)
	iter.connect(x, 0)
	return x
end

class ExtractIterator < UnaryIterator
	def initialize(regexp)
		super()
		@regexp = regexp
	end

	def evaluate(inputs)
		value = inputs[0]
		match = @regexp.match(value)
		if !match.nil?
			return match[1]
		end
		return nil
	end
end

def extract(iter, regexp)
	x = ExtractIterator.new(regexp)
	iter.connect(x, 0)
	return x
end

class ReplaceByProgramOutputIterator < UnaryIterator
	def initialize(command)
		super()
		@command = command
	end

	def evaluate(inputs)
		return `#{@command}`
	end
end

def replace_by_program_output(iter, command)
	x = ReplaceByProgramOutputIterator.new(command)
	iter.connect(x, 0)
	return x
end

class ToFloatIterator < UnaryIterator
	def evaluate(inputs)
		result = nil
		if !inputs[0].nil?
			result = inputs[0].to_f
		end
		return result 
	end
end

def to_float(iter)
	x = ToFloatIterator.new
	iter.connect(x, 0)
	return x
end

class SubtractIterator < BinaryIterator
	def evaluate(inputs)
		return inputs[0] - inputs[1]
	end
end

def subtract(iter0, iter1)
	x = SubtractIterator.new
	iter0.connect(x, 0)
	iter1.connect(x, 1)
	return x
end
