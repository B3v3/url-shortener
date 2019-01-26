FactoryBot.define do
  factory :url do
    link { "https://www.google.com"}
    shortening { "guugle"}
    days_to_delete { 1 }
  end
end
