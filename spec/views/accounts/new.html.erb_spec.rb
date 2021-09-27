require 'rails_helper'

RSpec.describe "accounts/new", type: :view do
  before(:each) do
    assign(:account, Account.new(
      account_type: nil,
      code: "MyString",
      description: "MyString"
    ))
  end

  it "renders new account form" do
    render

    assert_select "form[action=?][method=?]", accounts_path, "post" do

      assert_select "input[name=?]", "account[account_type_id]"

      assert_select "input[name=?]", "account[code]"

      assert_select "input[name=?]", "account[description]"
    end
  end
end
