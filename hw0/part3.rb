class BookInStock
	
	def initialize(isbn, price)
		checkISBN isbn
		checkPrice price
		@isbn = isbn
		@price = price
	end

	def isbn
		@isbn
	end

	def price
		@price
	end

	def isbn=(isbn)
		checkISBN isbn
		@isbn = isbn
	end

	def price=(price)
		checkPrice price
		@price = price
	end

	def price_as_string
		puts "@price, #{@price}"
		integer, decimal = (@price.to_s).split(".")
		puts "integer: #{integer}"
		puts "decimal: #{decimal}"
		if decimal == nil
			return "$" + integer + ".00"
		else
			decimal = decimal.to_s.split("")
			2.times do |n|
				if decimal[n] == nil
					decimal[n] = '0'
				end
			end
			return "$" + integer.to_s + "." + decimal.join("")[0..1]
		end
	end

	private 
	def checkISBN(isbn)
		if isbn == ""
			raise ArgumentError
		end
	end

	def checkPrice(price)
		if price <= 0
			raise ArgumentError
		end
	end
end