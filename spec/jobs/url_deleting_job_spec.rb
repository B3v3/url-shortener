require 'rails_helper'

RSpec.describe UrlDeletingJob, type: :job do
  let(:url) { build(:url)}
  describe 'deleting url' do
    it "deletes a url" do
      url.save
      expect{ UrlDeletingJob.perform_now(url)}.to change(Url, :count).by(-1)
    end
  end

  describe 'queue after creating url' do
    it "queue a job after creating a url" do
      ActiveJob::Base.queue_adapter = :test
        expect {
        url.save
      }.to have_enqueued_job.with(url).on_queue("default")
    end
  end
end
