module ApplicationHelper

	def title(*parts)
		unless parts.empty?
			content_for :title do
				(parts << "100 Motels").join(" - ") unless parts.empty?
			end
		end
	end

  def admins_only(&block)
    block.call if current_user.try(:admin?)
    nil
  end

  def cart_items(cart)
    if cart == nil
      "0"
    else
      cart.line_items.to_a.sum { |item| item.quantity }
    end
  end
end
