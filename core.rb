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

	def enqueue(i, value)
		# puts("received #{value} by #{self} (#{i})")
		@input_queue[i] << value
	end

	def send(i, value)
		enqueue(i, value)

		while handle_input_queue
		end
	end

	def handle_input_queue
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

			skip = false
			inputs.each do |x|
				if x.nil?
					skip = true
				end
			end
			if !skip
				result = evaluate(inputs)
			else
				result = nil
			end

			@connections.each do |connetion|
				iter, i = connetion
				iter.send(i, result)
			end
		end

		return ready
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

class Source < UnaryIterator
	@@all_sources = []

	def initialize
		super()
		@@all_sources << self
	end

	def self.all_sources
		return @@all_sources
	end
end

def prev(iter)
	x = UnaryIterator.new
	x.enqueue(0, nil)
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
