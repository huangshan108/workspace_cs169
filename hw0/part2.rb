def hello(name)
	return "Hello, " + name
end

# puts hello "Shan"

def starts_with_consonant?(s)
	if s[0] == nil
		return false
	else
		starts_with_letter = s =~ /[A-Za-z]/ 
		not_consonant = s =~ /[AaEeIiOoUu]/
		return (starts_with_letter == 0 and not_consonant != 0)
	end
end

# puts starts_with_consonant?("Shan")
# puts starts_with_consonant?("I am Shan")

def binary_multiple_of_4?(s)
	if s == ""
		return false
	end
	result = 0
	s.split("").each do |n|
		if n == '0' or n == '1'
			result = result * 2 + n.to_i
		else
			return false
		end
	end
	return result % 4 == 0
end

# puts binary_multiple_of_4?("100")
# puts binary_multiple_of_4?("101")
# puts binary_multiple_of_4?("10x")