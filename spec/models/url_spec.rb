require 'rails_helper'

RSpec.describe Url, type: :model do
  let(:url) { build(:url) }

  describe "validations" do
    it "should accept valid models" do
      expect(url.valid?).to be_truthy
    end

    describe "link" do
      it "should exists" do
        url.link = ""
        expect(url.valid?).to be_falsey
      end
      it "should be longer than 2 characters" do
        url.link = "ww"
        expect(url.valid?).to be_falsey
      end
      it "should be shorter than 256 characters" do
        url.link = "a" * 256
        expect(url.valid?).to be_falsey
      end
    end

    describe "shortening" do
      it "should only contain alphanumerical characters" do
        url.shortening = "fsa-2/a"
        expect(url.valid?).to be_falsey
      end
      it "should be longer than 3 characters" do
        url.shortening = "new"
        expect(url.valid?).to be_falsey
      end
      it "should be shorter than 17 characters" do
        url.shortening = "a" * 17
        expect(url.valid?).to be_falsey
      end
    end
  end

  describe ".check_protocol_existence" do
    it "adds https if there no protocol" do
      url.link = "www.google.pl"
      url.save
      url.reload
      expect(url.link).to eql("http://www.google.pl")
    end
    it "doesnt do anything if there is a protocol" do
      url.link = "https://www.google.pl"
      url.save
      url.reload
      expect(url.link).to eql("https://www.google.pl")
    end
  end

  describe ".set_shortening_if_non" do
    it "create shortening if theres non" do
      url.shortening = ""
      url.save
      url.reload
      expect(url.shortening.length).to eql(16)
    end
    it "change nothing if there is shortening" do
      url.shortening = "hellowword"
      url.save
      url.reload
      expect(url.shortening).to eql("hellowword")
    end
  end

  describe ".set_days_to_delete_if_non" do
    it "set days to 1 if there aren't set" do
      url.days_to_delete = ""
      url.save
      url.reload
      expect(url.days_to_delete).to eq(1)
    end

    it "set days to 1 if less than 1" do
      url.days_to_delete = 0
      url.save
      url.reload
      expect(url.days_to_delete).to eq(1)
    end

    it "set days to 1 if greater than 10" do
      url.days_to_delete = 11
      url.save
      url.reload
      expect(url.days_to_delete).to eq(1)
    end

    it "doesnt change anything if there're set" do
      url.days_to_delete = 8
      url.save
      url.reload
      expect(url.days_to_delete).to eq(8)
    end
  end
end
