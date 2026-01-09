# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

AuthenticationProvider.create!(name: 'kakao')
AuthenticationProvider.create!(name: 'twitter')
AuthenticationProvider.create!(name: 'google_oauth2')
AuthenticationProvider.create!(name: 'apple')
AuthenticationProvider.create!(name: 'facebook')
AuthenticationProvider.create!(name: 'naver')
AuthenticationProvider.create!(name: 'github')

Payment.create!(:id => 1, :title => '현금결제')
Payment.create!(:id => 2, :title => '카드결제')
Payment.create!(:id => 3, :title => '포인트결제')
Payment.create!(:id => 4, :title => '추후청구')
Payment.create!(:id => 5, :title => '핸드폰결제')
Payment.create!(:id => 6, :title => '계좌이체')
Payment.create!(:id => 7, :title => '가상계좌')
Payment.create!(:id => 8, :title => '무통장입금')


UserType.create!(id: 1, title: '익명사용자만 사용')
UserType.create!(id: 2, title: '회원만 사용')
UserType.create!(id: 3, title: '회원 및 익명사용자')

Company.create!(id: 1, title: '피씨방')
Company.create!(id: 2, title: '매점')
Company.create!(id: 3, title: '임시 매점')

Branch.create!(id: 1, company_id: 1, title: '피씨방', sample: true, branch_setting_attributes: { use_unique_number: true, branch_setting_user_type_attributes: { user_type_id: 1 }, branch_setting_payments_attributes: [{ payment_id: 1 }, { payment_id: 2 }, { payment_id: 3 }, { payment_id: 4 }] })
Branch.create!(id: 2, company_id: 2, title: '매점', branch_setting_attributes: { use_unique_number: true, branch_setting_user_type_attributes: { user_type_id: 2 }, branch_setting_payments_attributes: [{ payment_id: 1 }, { payment_id: 2 }] })
Branch.create!(id: 3, company_id: 3, title: '임시 매점', branch_setting_attributes: { use_unique_number: false, branch_setting_user_type_attributes: { user_type_id: 1 }, branch_setting_payments_attributes: [{ payment_id: 3 }, { payment_id: 4 }] })

Role.create!(id: 1, title: '전체관리자', role: 'super_administrator')
Role.create!(id: 2, title: '관리자', role: 'administrator')
Role.create!(id: 3, title: '보조관리자', role: 'sub_administrator')
Role.create!(id: 4, title: '운영자', role: 'operator')
Role.create!(id: 5, title: '보조운영자', role: 'sub_operator')
Role.create!(id: 6, title: '알바생', role: 'reader')

User.create!(id: 1, branch_id: 1, email: 'user1@jedaeroweb.co.kr', password: 'a12345', password_confirmation: 'a12345', name: '사용자1', phone: '111-1111', registration_date: '2020-11-23')
User.create!(id: 2, branch_id: 1, email: 'user2@jedaeroweb.co.kr', password: 'a12345', password_confirmation: 'a12345', name: '사용자2', phone: '222-2222', registration_date: '2020-11-23')
User.create!(id: 3, branch_id: 1, email: 'user3@jedaeroweb.co.kr', password: 'a12345', password_confirmation: 'a12345', name: '사용자3', phone: '333-3333', registration_date: '2020-11-23')
User.create!(id: 4, branch_id: 1, email: 'user4@jedaeroweb.co.kr', password: 'a12345', password_confirmation: 'a12345', name: '사용자4', phone: '444-4444', registration_date: '2020-11-23')

#User.create!(id: 5, branch_id: 2, email: 'user5@jedaeroweb.co.kr', password: 'a12345', password_confirmation: 'a12345', name: '사용자4', phone: '555-5555', registration_date: '2020-11-23')
#User.create!(id: 6, branch_id: 2, email: 'user6@jedaeroweb.co.kr', password: 'a12345', password_confirmation: 'a12345', name: '사용자4', phone: '666-6666', registration_date: '2020-11-23')
#User.create!(id: 7, branch_id: 2, email: 'user7@jedaeroweb.co.kr', password: 'a12345', password_confirmation: 'a12345', name: '사용자4', phone: '777-7777', registration_date: '2020-11-23')
#User.create!(id: 8, branch_id: 2, email: 'user8@jedaeroweb.co.kr', password: 'a12345', password_confirmation: 'a12345', name: '사용자4', phone: '888-8888', registration_date: '2020-11-23')

#User.create!(id: 9, branch_id: 3, email: 'user9@jedaeroweb.co.kr', password: 'a12345', password_confirmation: 'a12345', name: '사용자4', phone: '999-9999', registration_date: '2020-11-23')
#User.create!(id: 10, branch_id: 3, email: 'user10@jedaeroweb.co.kr', password: 'a12345', password_confirmation: 'a12345', name: '사용자4', phone: '121-1211', registration_date: '2020-11-23')
#User.create!(id: 11, branch_id: 3, email: 'user11@jedaeroweb.co.kr', password: 'a12345', password_confirmation: 'a12345', name: '사용자4', phone: '333-4444', registration_date: '2020-11-23')
#User.create!(id: 12, branch_id: 3, email: 'user12@jedaeroweb.co.kr', password: 'a12345', password_confirmation: 'a12345', name: '사용자4', phone: '444-5555', registration_date: '2020-11-23')

branch_setting=BranchSetting.find(1)
branch_setting.user_id = 1
branch_setting.save!

#User.create!(id: 13, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '익명사용자')
#User.create!(id: 14, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자1', phone: '111-1111')
#User.create!(id: 15, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자2', phone: '222-2222')
#User.create!(id: 16, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자3', phone: '333-3333')
#User.create!(id: 17, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자4', phone: '444-4444')
#User.create!(id: 18, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자1', phone: '111-2222')
#User.create!(id: 19, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자2', phone: '222-3333')
#User.create!(id: 20, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자3', phone: '333-4444')
#User.create!(id: 21, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자4', phone: '444-5555')
#User.create!(id: 22, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자1', phone: '111-1212')
#User.create!(id: 23, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자2', phone: '222-1313')
#User.create!(id: 24, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자3', phone: '333-1414')
#User.create!(id: 25, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자4', phone: '444-1515')
#User.create!(id: 26, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자1', phone: '111-5555')
#User.create!(id: 27, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자2', phone: '222-6666')
#User.create!(id: 28, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자3', phone: '333-7777')
#User.create!(id: 29, branch_id: 1, email: nil, password: nil, password_confirmation: nil, name: '사용자4', phone: '444-8888')

Admin.create!(id: 1, branch_id: 1, name: '잠자는-사자', role_admin_attributes: { role_id: 1 })
Admin.create!(id: 2, branch_id: 1, name: '트레이너', role_admin_attributes: { role_id: 3 })
Admin.create!(id: 3, branch_id: 1, name: 'FC',role_admin_attributes: { role_id: 3 })

#RoleAdmin.create!(role_id: 1, admin_id: 1)
#RoleAdmin.create!(role_id: 1,admin_id: 2)
#RoleAdmin.create!(role_id: 2,admin_id: 3)
#RoleAdmin.create!(role_id: 3,admin_id: 4)
#RoleAdmin.create!(role_id: 4,admin_id: 5)

UserAdmin.create!(user_id: 1, admin_id: 1)
UserAdmin.create!(user_id: 5, admin_id: 2)
UserAdmin.create!(user_id: 9, admin_id: 3)

AccountCategory.create!(id: 1, title: '구입', enable: true)
AccountCategory.create!(id: 2, title: '수정', enable: true)
AccountCategory.create!(id: 3, title: '환불', enable: true)
AccountCategory.create!(id: 4, title: '포인트충전', enable: true)
AccountCategory.create!(id: 5, title: '포인트환불', enable: true)

ProductCategory.create!(id: 1, branch_id: 1, title: '커피', enable: true)
ProductCategory.create!(id: 2, branch_id: 1, title: '음료', enable: true)
ProductCategory.create!(id: 3, branch_id: 1, title: '간식', enable: true)

ProductCategory.create!(id: 4, branch_id: 2, title: '커피', enable: true)
ProductCategory.create!(id: 5, branch_id: 2, title: '캔', enable: true)
ProductCategory.create!(id: 6, branch_id: 2, title: '빵', enable: true)

ProductCategory.create!(id: 7, branch_id: 3, title: '음료', enable: true)
ProductCategory.create!(id: 8, branch_id: 3, title: '과자', enable: true)

Product.create!(id: 1, branch_id: 1, product_category_id: 1, title: '아메리카노', price: 2000, enable: true)
Product.create!(id: 2, branch_id: 1, product_category_id: 1, title: '라떼', price: 2000, enable: true)
Product.create!(id: 3, branch_id: 1, product_category_id: 2, title: '우유', price: 2000, enable: true)
Product.create!(id: 4, branch_id: 1, product_category_id: 2, title: '콜라', price: 2000, enable: true)
Product.create!(id: 5, branch_id: 1, product_category_id: 2, title: '사이다', price: 2000, enable: true)
Product.create!(id: 6, branch_id: 1, product_category_id: 3, title: '라면', price: 2000, enable: true)
Product.create!(id: 7, branch_id: 1, product_category_id: 3, title: '빵', price: 2000, enable: true)
Product.create!(id: 8, branch_id: 2, product_category_id: 3, title: '과자', price: 2000, enable: true)
Product.create!(id: 9, branch_id: 2, product_category_id: 4, title: '아메리카노', price: 2000, enable: true)
Product.create!(id: 10, branch_id: 2, product_category_id: 4, title: '라떼', price: 2000, enable: true)
Product.create!(id: 11, branch_id: 2, product_category_id: 5, title: '사이다', price: 2000, enable: true)
Product.create!(id: 12, branch_id: 2, product_category_id: 5, title: '콜라', price: 2000, enable: true)
Product.create!(id: 13, branch_id: 2, product_category_id: 5, title: '주스', price: 2000, enable: true)
Product.create!(id: 14, branch_id: 2, product_category_id: 6, title: '단팥빵', price: 2000, enable: true)
Product.create!(id: 15, branch_id: 2, product_category_id: 6, title: '공갈빵', price: 2000, enable: true)
Product.create!(id: 16, branch_id: 3, product_category_id: 7, title: '콜라', price: 2000, enable: true)
Product.create!(id: 17, branch_id: 3, product_category_id: 8, title: '감자칩', price: 2000, enable: true)

ProductPicture.create!(product_id: 1, picture: File.open(Rails.root.join("app", "assets", "images","ice_coffee.jpg")))
ProductPicture.create!(product_id: 1, picture: File.open(Rails.root.join("app", "assets", "images","ice_coffee.jpg")))
ProductPicture.create!(product_id: 1, picture: File.open(Rails.root.join("app", "assets", "images","ice_coffee.jpg")))

ProductPicture.create!(product_id: 2, picture: File.open(Rails.root.join("app", "assets", "images","latte.png")))
ProductPicture.create!(product_id: 2, picture: File.open(Rails.root.join("app", "assets", "images","latte.png")))
ProductPicture.create!(product_id: 2, picture: File.open(Rails.root.join("app", "assets", "images","latte.png")))

ProductPicture.create!(product_id: 5, picture: File.open(Rails.root.join("app", "assets", "images","cider.jpg")))
ProductPicture.create!(product_id: 5, picture: File.open(Rails.root.join("app", "assets", "images","cider.jpg")))
ProductPicture.create!(product_id: 5, picture: File.open(Rails.root.join("app", "assets", "images","cider.jpg")))

Group.create!(id: 1, branch_id: 1, title: 'VIP')
Group.create!(id: 2, branch_id: 1, title: 'Special')
Group.create!(id: 3, branch_id: 1, title: 'Normal')

I18n.locale = :en

role = Role.find(1)
role.title = 'super administrator'
role.save!

role = Role.find(2)
role.title = 'administrator'
role.save!

role = Role.find(3)
role.title = 'sub administrator'
role.save!

role = Role.find(4)
role.title = 'operator'
role.save!

role = Role.find(5)
role.title = 'sub operator'
role.save!

role = Role.find(6)
role.title = 'reader'
role.save!

payment = Payment.find(1)
payment.title = 'cash'
payment.save!

payment = Payment.find(2)
payment.title = 'card'
payment.save!

payment = Payment.find(3)
payment.title = 'point'
payment.save!

payment = Payment.find(4)
payment.title = 'admin'
payment.save!

payment = Payment.find(5)
payment.title = 'cellphone'
payment.save!

payment = Payment.find(6)
payment.title = 'account transaction'
payment.save!

payment = Payment.find(7)
payment.title = 'admin'
payment.save!

payment = Payment.find(8)
payment.title = 'admin'
payment.save!

user_type = UserType.find(1)
user_type.title = 'use members only'
user_type.save!

user_type = UserType.find(2)
user_type.title = 'not use members / only anon'
user_type.save!

user_type = UserType.find(3)
user_type.title = 'use members and anon'
user_type.save!

account_category = AccountCategory.find(1)
account_category.title = 'buy'
account_category.save!

account_category = AccountCategory.find(2)
account_category.title = 'refund'
account_category.save!

account_category = AccountCategory.find(3)
account_category.title = 'charge_point'
account_category.save!

account_category = AccountCategory.find(4)
account_category.title = 'refund point'
account_category.save!


product_category = ProductCategory.find(1)
product_category.title = 'coffee'
product_category.save!

product_category = ProductCategory.find(2)
product_category.title = 'beverage'
product_category.save!

product_category = ProductCategory.find(3)
product_category.title = 'snack'
product_category.save!

product = Product.find(1)
product.title = 'coffee'
product.save!

product = Product.find(2)
product.title = 'latte'
product.save!

product = Product.find(3)
product.title = 'milk'
product.save!

product = Product.find(4)
product.title = 'coke'
product.save!

product = Product.find(5)
product.title = 'cider'
product.save!

product = Product.find(6)
product.title = 'ramen(noodle)'
product.save!

product = Product.find(7)
product.title = 'bread'
product.save!


I18n.locale = :'zh-CN'

payment = Payment.find(1)
payment.title = 'cash'
payment.save!

payment = Payment.find(2)
payment.title = 'card'
payment.save!

payment = Payment.find(3)
payment.title = 'point'
payment.save!

payment = Payment.find(4)
payment.title = 'admin'
payment.save!

payment = Payment.find(5)
payment.title = 'admin'
payment.save!

payment = Payment.find(6)
payment.title = 'admin'
payment.save!

payment = Payment.find(7)
payment.title = 'admin'
payment.save!

payment = Payment.find(8)
payment.title = 'admin'
payment.save!

user_type = UserType.find(1)
user_type.title = 'use members only'
user_type.save!

user_type = UserType.find(2)
user_type.title = 'not use members / only anon'
user_type.save!

user_type = UserType.find(3)
user_type.title = 'use members and anon'
user_type.save!

account_category = AccountCategory.find(1)
account_category.title = 'buy'
account_category.save!

account_category = AccountCategory.find(2)
account_category.title = 'refund'
account_category.save!

account_category = AccountCategory.find(3)
account_category.title = 'charge_point'
account_category.save!

account_category = AccountCategory.find(4)
account_category.title = 'refund point'
account_category.save!

role = Role.find(1)
role.title = 'super administrator'
role.save!

role = Role.find(2)
role.title = 'administrator'
role.save!

role = Role.find(3)
role.title = 'sub administrator'
role.save!

role = Role.find(4)
role.title = 'operator'
role.save!

role = Role.find(5)
role.title = 'sub operator'
role.save!

role = Role.find(6)
role.title = 'reader'
role.save!

product_category = ProductCategory.find(1)
product_category.title = '咖啡'
product_category.save!

product_category = ProductCategory.find(2)
product_category.title = '饮料'
product_category.save!

product_category = ProductCategory.find(3)
product_category.title = '小吃'
product_category.save!

product = Product.find(1)
product.title = '美式咖啡'
product.save!

product = Product.find(2)
product.title = '拿铁'
product.save!

product = Product.find(3)
product.title = '牛奶'
product.save!

product = Product.find(4)
product.title = '可乐'
product.save!

product = Product.find(5)
product.title = '雪碧'
product.save!

product = Product.find(6)
product.title = '拉面'
product.save!

product = Product.find(7)
product.title = '面包'
product.save!



I18n.locale = :ja

role = Role.find(1)
role.title = 'super administrator'
role.save!

role = Role.find(2)
role.title = 'administrator'
role.save!

role = Role.find(3)
role.title = 'sub administrator'
role.save!

role = Role.find(4)
role.title = 'operator'
role.save!

role = Role.find(5)
role.title = 'sub operator'
role.save!

role = Role.find(6)
role.title = 'reader'
role.save!

payment = Payment.find(1)
payment.title = 'cash'
payment.save!

payment = Payment.find(2)
payment.title = 'card'
payment.save!

payment = Payment.find(3)
payment.title = 'point'
payment.save!

payment = Payment.find(4)
payment.title = 'admin'
payment.save!

payment = Payment.find(5)
payment.title = 'cellphone'
payment.save!

payment = Payment.find(6)
payment.title = 'account transaction'
payment.save!

payment = Payment.find(7)
payment.title = 'admin'
payment.save!

payment = Payment.find(8)
payment.title = 'admin'
payment.save!

user_type = UserType.find(1)
user_type.title = 'use members only'
user_type.save!

user_type = UserType.find(2)
user_type.title = 'not use members / only anon'
user_type.save!

user_type = UserType.find(3)
user_type.title = 'use members and anon'
user_type.save!

account_category = AccountCategory.find(1)
account_category.title = 'buy'
account_category.save!

account_category = AccountCategory.find(2)
account_category.title = 'refund'
account_category.save!

account_category = AccountCategory.find(3)
account_category.title = 'charge_point'
account_category.save!

account_category = AccountCategory.find(4)
account_category.title = 'refund point'
account_category.save!


product_category = ProductCategory.find(1)
product_category.title = 'コーヒー'
product_category.save!

product_category = ProductCategory.find(2)
product_category.title = '飲み物'
product_category.save!

product_category = ProductCategory.find(3)
product_category.title = 'スナック'
product_category.save!

product = Product.find(1)
product.title = 'コーヒー'
product.save!

product = Product.find(2)
product.title = 'カフェーオレ'
product.save!

product = Product.find(3)
product.title = '牛乳'
product.save!

product = Product.find(4)
product.title = 'coke'
product.save!

product = Product.find(5)
product.title = 'cider'
product.save!

product = Product.find(6)
product.title = '拉麺'
product.save!

product = Product.find(7)
product.title = 'パン'
product.save!