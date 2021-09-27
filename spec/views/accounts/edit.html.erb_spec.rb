require 'rails_helper'

RSpec.describe "accounts/edit", type: :view do
  before(:each) do
    @account = assign(:account, Account.create!(
      account_type: nil,
      code: "MyString",
      description: "MyString"
    ))
  end

  it "renders the edit account form" do
    render

    assert_select "form[action=?][method=?]", account_path(@account), "post" do

      assert_select "input[name=?]", "account[account_type_id]"

      assert_select "input[name=?]", "account[code]"

      assert_select "input[name=?]", "account[description]"
    end
  end
end
