class Comment < ActiveRecord::Base
  belongs_to :installation

  def subtotal       
   	 price * quantity
  end

  end