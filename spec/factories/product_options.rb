FactoryGirl.define do
  factory :product_option do
    name 'name'
    selector '.selector'
    selector_type 'css'
    site
  end
end