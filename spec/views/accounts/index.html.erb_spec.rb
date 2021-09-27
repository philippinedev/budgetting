require 'rails_helper'

RSpec.describe "accounts/index", type: :view do
  before(:each) do
    assign(:accounts, [
      Account.create!(
        account_type: nil,
        code: "Code",
        description: "Description"
      ),
      Account.create!(
        account_type: nil,
        code: "Code",
        description: "Description"
      )
    ])
  end

  it "renders a list of accounts" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "Code".to_s, count: 2
    assert_select "tr>td", text: "Description".to_s, count: 2
  end
end
