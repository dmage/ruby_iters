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

def run
	while true
		Source.all_sources.each do |x|
			x.run()
		end
	end
end
