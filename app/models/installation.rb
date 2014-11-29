class Installation < ActiveRecord::Base
	has_many :comments

	def total_price
 	 comments.to_a.sum(&:subtotal)
	end
end
