# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
  before do
   @user = User.new(name: "Example User", email: "user@example.com", 
                     password: "foobar", password_confirmation: "foobar")end
  subject{@user}
  it{should respond_to(:name)}
  it{should respond_to(:email)}
  it{should respond_to(:password_digest)}
  it{should respond_to(:password)}
  it{should respond_to(:password_confirmation)}
  it{should respond_to(:authenticate)}
  it{should be_valid}
  
  describe "khi truong ten bo trong"  do
  	before{@user.name=" "}
  	it{should_not be_valid} 

  end
  	describe "when email is not present" do
    before { @user.email = " " }
   
    it { should_not be_valid }
  end
  describe "khi ten dai qua 32 ky tu" do
    before{@user.name='a'*33}
    it{should_not be_valid}

  end
  describe "truong hop khong dung dinh dang email" do
   it "should be invalid" do
   add=  %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
    add.each do |add|
      @user.email=add
      @user.should_not be_valid
    end
   end
  end

  describe "truong hop dung dinh dang email" do
    it "should be valid" do
    add= %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
     add.each  do |add|
      @user.email=add
      @user.should be_valid
    end
    end
  end

describe "khi email da ton tai" do
  before do
    user_with_same_email=@user.dup
    user_with_same_email.email=@user.email.upcase
    user_with_same_email.save

  end
  it {should_not be_valid}
end
   
describe "khi password va mat khau khong trung nhau" do
  before{@user.password_confirmation="mismatch"}
  it{should_not be_valid}
end

describe "khi mat khau va mat khau xac thuc khong dung" do
 before {@user.password=@user.password_confirmation=" "}
 it{should_not be_valid}
end

describe "khi mat khau xac thuc la rong" do
  before{@user.password_confirmation=nil}
  it{should_not be_valid}
end

 describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

end
