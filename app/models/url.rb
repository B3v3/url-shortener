class Url < ApplicationRecord
  extend FriendlyId
  friendly_id :shortening, use: :slugged

  before_validation :set_days_to_delete_if_non
  before_validation :set_shortening_if_non
  before_save :check_protocol_existence
  after_save :url_expiring

  VALID_SHORTENING_REGEX = /\A[a-z0-9\-_]+\z/i
  validates :shortening, presence: true, length: { minimum: 4, maximum: 16 },
                                     uniqueness: { case_sensitive: true },
                                     format: { with: VALID_SHORTENING_REGEX }

  validates :link, presence: true, length: { minimum: 3, maximum: 255 }
  validates :days_to_delete, presence: true, numericality: { only_integer: true,
                                                             less_than: 11,
                                                             greater_than: 0}



  protected
    def set_shortening_if_non
      if self.shortening.blank?
        self.shortening = create_shortening
      end
    end

    def set_days_to_delete_if_non
      self.days_to_delete = 1 if !(1..10).include?(self.days_to_delete)
    end

    # to check if http/https is present and when not to add it
    def check_protocol_existence
      unless /^http/ === self.link
        self.link = "http://" + "#{self.link}"
      end
    end

    def url_expiring
      UrlDeletingJob.set(wait: (self.days_to_delete).days).perform_later(self)
    end

  private
    def generate_shortening
      short = ""
      pool = ((0...36).map{ |i| i.to_s 36})

      16.times do
       short = short + pool.sample
      end

      return short
    end

    def create_shortening
      short = generate_shortening

      while Url.find_by(shortening: short).present?
       short = generate_short
      end

      return short
    end
end
