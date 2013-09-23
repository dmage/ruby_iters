require 'core'

class TextFile < Source
	def initialize(filename)
		super()
		@filename = filename
		@f = File.open(@filename, "r")
	end

	def run
		if select([@f], [], [], 1)
			line = @f.gets
			self.send(0, line)
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

def display(iter)
	x = DisplayIterator.new()
	iter.connect(x, 0)
	return x
end

def extract(iter, regexp)
	x = ExtractIterator.new(regexp)
	iter.connect(x, 0)
	return x
end

def run
	while true
		Source.all_sources.each do |x|
			x.run()
		end
	end
end
