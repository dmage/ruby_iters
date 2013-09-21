class Iterator
	def initialize(n_ary)
		@connections = []

		@input_queue = []
		(1..n_ary).each do |i|
			@input_queue << []
		end
	end

	def connect(iter, i)
		@connections << [iter, i]
	end

	def send(i, value)
		# puts("received #{value} by #{self} (#{i})")

		@input_queue[i] << value

		ready = true
		@input_queue.each do |queue|
			if queue.size == 0
				ready = false
			end
		end

		if ready
			inputs = []
			@input_queue.each do |queue|
				inputs << queue.shift
			end

			inputs.each do |x|
				if x.nil?
					# puts("rejecting inputs #{inputs}")
					return
				end
			end
			result = evaluate(inputs)

			@connections.each do |connetion|
				iter, i = connetion
				iter.send(i, result)
			end
		end
	end

	def evaluate(inputs)
		return inputs[0]
	end
end

class UnaryIterator < Iterator
	def initialize
		super(1)
	end
end

class BinaryIterator < Iterator
	def initialize
		super(2)
	end
end

$all_sources = []
class Source < UnaryIterator
	def initialize
		super()
		$all_sources << self
	end
end

# end of core library

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

#begin
log_file = TextFile.new('./some.log')
display(log_file)
display(extract(log_file, /([0-9]+)/))
#end

while true
	$all_sources.each do |x|
		x.run()
	end
end
