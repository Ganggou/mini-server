FactoryBot.define do
  factory :user do
    sequence(:wx_openid, 10) { |n| "wx_openid#{n}" }
  end
end
