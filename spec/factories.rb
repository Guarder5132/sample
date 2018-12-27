FactoryGirl.define do
    factory :user do
        #sequence方法可以接受一个Symbol类型的参数
        sequence(:name) { |n| "Person #{n}" }
        sequence(:email) { |n| "person_#{n}@example.com"}
        password "foobar"
        password_confirmation "foobar"

        factory :admin do
            admin true
        end
    end
end