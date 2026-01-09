class Admin::OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "admin_orders"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
