class Sam
	def method_missing(meth)
		if meth.to_s =~ /^is_(.+)\?$/
			"Yup, he's #{$1}"
		else
			super
		end
	end
end

def foo arr; arr.inject(:+); end
foo [1,2,3,4,5] # => 15

def bar(hsh)
	hsh.select { |k, v| v > 100 }
end

bar({:a => 1, :b => 200, :c => 300})
bar :a => 1, :b => 200, :c => 300

def fib n
	first = 0
	second = 1
	count = 0
	while count < n
		temp = first + second
		yield second
		count += 1
		first = second
		second = temp
	end	
	return nil
end

class Array
	def odds
		for i in 0...self.size
			if i % 2 != 0
				yield self[i]
			end
		end
		return nil
	end
end

[10, 30, 50, 70, 90].odds do |n|
	puts n
end