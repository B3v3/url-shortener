class UrlDeletingJob < ApplicationJob
  queue_as :default

  def perform(url)
    url.delete
  end
end
