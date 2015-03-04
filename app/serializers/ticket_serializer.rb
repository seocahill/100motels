class TicketSerializer < ActiveModel::Serializer
  attributes :id, :number, :admitted, :order_id
end
