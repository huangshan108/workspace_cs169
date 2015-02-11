def sum arr
	if arr.empty?
		return 0
	end
	return arr.inject(:+)
end

# puts sum [1,2,3,4,5,6]
# puts sum []

def max_2_sum arr
	if arr.empty?
		return 0
	elsif arr.length == 1
		return arr[0]
	else
		largest = -Float::INFINITY
		larger = -Float::INFINITY
		arr.each do |n|
			if n > largest
				larger = largest
				largest = n
			elsif n > larger
				larger = n
			end
		end
		return largest + larger
	end
end

# puts max_2_sum [1,3,4,2,4,6,5,1]
# puts max_2_sum []
# puts max_2_sum [9]

def sum_to_n? arr, n
	if arr.length <= 1
		return false
	else
		arr.combination(2).detect { |a, b| a + b == n } != nil
	end
end

# sum_to_n? [], 2 # => false
# sum_to_n? [1], 1 # => false
# sum_to_n? [1,2,4,2,6,3,5], 10 # => true