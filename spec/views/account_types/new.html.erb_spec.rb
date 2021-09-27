require 'rails_helper'

RSpec.describe "account_types/new", type: :view do
  before(:each) do
    assign(:account_type, AccountType.new(
      name: "MyString",
      description: "MyString"
    ))
  end

  it "renders new account_type form" do
    render

    assert_select "form[action=?][method=?]", account_types_path, "post" do

      assert_select "input[name=?]", "account_type[name]"

      assert_select "input[name=?]", "account_type[description]"
    end
  end
end
