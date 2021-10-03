# frozen_string_literal: true

# Entities seeder
class EntitiesSeeder
  class << self
    def call
      debits
      credits
      output
    end

    private

    def output
      [
        @expense,
        @tran_expense,
        @atm_withdraway_charge,
        @groceries,
        @groceries_mall,
        @groceries_other,
        @salary_expense,
        @rent_expense,
        @internet_expense,
        @cashables,
        @cash_on_hand,
        @bank_account,
        @credit_cards,
        @cc_bdo_pri,
        @cc_bdo_ins,
        @cc_rcbc_pri,
        @cc_rcbc_flex,
        @cc_rcbc_jcb,
        @cc_rcbc_ins,
        @cc_metrobank,
        @income,
        @unidentified_income,
        @income_programming,
        @erich,
        @morphosis,
        @unidentified_expense,
        @unidentified_cc_expense,
      ]
    end

    def bank_accounts
      @bdo_account1 = Entity.create(name: 'BDO Acct: 005010246385', parent_id: @bank_account.id)
    end


    def debits
      expense
      tran_expense
      atm_withdraway_charge
      unindentifieds
      groceries
      salary_expense
      rent_expense
      internet_expense
    end

    def credits
      cashables
      bank_accounts
      credit_cards
      income
    end

    def expense
      @expense = Entity.create(name: 'Expenses')
    end

    def tran_expense
      @tran_expense = Entity.create(
        id: Entity::TRANSACTION_CHARGES_ID,
        name: 'Transaction Expenses',
        parent_id: @expense.id
      )
    end

    def atm_withdraway_charge
      @atm_withdraway_charge = Entity.create(
        name: 'ATM Withdrawal Charge',
        parent_id: @tran_expense.id,
        transaction_fee: 18.0
      )
    end

    def groceries
      @groceries       = Entity.create(name: 'Groceries', parent_id: @expense.id)
      @groceries_mall  = Entity.create(name: 'Groceries at Mall', parent_id: @groceries.id)
      @groceries_other = Entity.create(name: 'Groceries (other)', parent_id: @groceries.id)
    end

    def salary_expense
      @salary_expense = Entity.create(name: 'Salary Expenses', parent_id: @expense.id)
      Entity.create(name: 'Ever Jedi Usbal', parent_id: @salary_expense.id)
      Entity.create(name: 'Don Forrest Usbal', parent_id: @salary_expense.id)
      Entity.create(name: 'Abe Cambarihan', parent_id: @salary_expense.id)
      Entity.create(name: 'Lester Quiñones', parent_id: @salary_expense.id)
      Entity.create(name: 'Paulo Benemerito', parent_id: @salary_expense.id)
      Entity.create(name: 'Abbie Mercado', parent_id: @salary_expense.id)
    end

    def rent_expense
      @rent_expense = Entity.create(name: 'Rent Expenses', parent_id: @expense.id)
      Entity.create(name: 'Issa House Mid', parent_id: @rent_expense.id)
      Entity.create(name: 'Issa House Back', parent_id: @rent_expense.id)
      Entity.create(name: 'Calderon House', parent_id: @rent_expense.id)
    end

    def internet_expense
      @internet_expense = Entity.create(name: 'Internet Expenses', parent_id: @expense.id)
      Entity.create(name: 'PLDT Landline', parent_id: @internet_expense.id)
      Entity.create(name: 'Converge Issa', parent_id: @internet_expense.id)
      Entity.create(name: 'Converge Calderon', parent_id: @internet_expense.id)
    end

    def cashables
      @cashables = Entity.create(name: 'Cashables')
      @cash_on_hand = Entity.create(name: 'Cash on Hand', parent_id: @cashables.id)
      @bank_account = Entity.create(name: 'Bank Account', parent_id: @cashables.id)
    end

    def credit_cards
      @credit_cards = Entity.create(name: 'Credit Card Payables')
      @cc_bdo_pri   = Entity.create(name: 'CC BDO PRI Payable', parent_id: @credit_cards.id)
      @cc_bdo_ins   = Entity.create(name: 'CC BDO INS Payable', parent_id: @credit_cards.id)
      @cc_rcbc_pri  = Entity.create(name: 'CC RCBC PRI Payable', parent_id: @credit_cards.id)
      @cc_rcbc_flex = Entity.create(name: 'CC RCBC FLEX Payable', parent_id: @credit_cards.id)
      @cc_rcbc_jcb  = Entity.create(name: 'CC RCBC JCB Payable', parent_id: @credit_cards.id)
      @cc_rcbc_ins  = Entity.create(name: 'CC RCBC INS Payable', parent_id: @credit_cards.id)
      @cc_metrobank = Entity.create(name: 'CC METROBANK', parent_id: @credit_cards.id)
    end

    def income
      @income = Entity.create(name: 'Incomes')
      @unidentified_income = Entity.create(name: 'Unidentified Incomes', parent_id: @income.id)
      @income_programming  = Entity.create(name: 'Income from programming', parent_id: @income.id)
      @erich     = Entity.create(name: 'Erich (Germany)', parent_id: @income_programming.id)
      @morphosis = Entity.create(name: 'Morphosis (Thailand)', parent_id: @income_programming.id)
    end

    def bank_accounts
      @bdo_account1 = Entity.create(name: 'BDO Acct: 005010246385', parent_id: @bank_account.id)
    end

    def unindentifieds
      @unidentified_expense    = Entity.create(name: 'Unidentified Expenses', parent_id: @expense.id)
      @unidentified_cc_expense = Entity.create(name: 'Unidentified Credit Card Expenses',
                                               parent_id: @unidentified_expense.id)
    end
  end
end
