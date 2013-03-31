FactoryGirl.define do
  factory :venue do
    static_logo 16515
    chain_id 35
    district_id 2338
    latitude 30.1635
    longitude -97.7429
    venue_type_id 1
    label "MRRT TX Austin - AUSAP"
    address_1 "4415 South IH-35"
    address_2 nil
    zip "78744"
    cache_url "http://s3amazon.com"
  end
end
