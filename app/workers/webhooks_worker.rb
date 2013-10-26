class RefundsWorker
  include Sidekiq::Worker

  def perform(event)
    # handle webhook
  end
end