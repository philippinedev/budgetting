import AddSelectionPrompt from '../shared/add_selection_prompt'
import AutoSelectSoleOption from '../shared/auto_select_sole_option'

export default class TransactionForm {
  constructor() {
    this.typeSel = document.getElementById('transaction_transaction_type_id')
    this.sourceSel = document.getElementById('transaction_source_account_id')
    this.targetSel = document.getElementById('transaction_target_account_id')

    this.initTransactionTypeSelector()
    this.onTransactionTypeChange(this.typeSel.value)
  }

  initTransactionTypeSelector() {
    this.typeSel.addEventListener('change', el => {
      this.onTransactionTypeChange(el.target.value)
    })
  }

  onTransactionTypeChange(id) {
    this.buildSelection(id, 'source')
    this.buildSelection(id, 'target')

    this.addSelectPrompt()
    new AutoSelectSoleOption([this.sourceSel, this.targetSel])
  }

  addSelectPrompt() {
    new AddSelectionPrompt(this.sourceSel, "Choose Source Account")
    new AddSelectionPrompt(this.targetSel, "Choose Target Account")
  }

  buildSelection(id, type) {
    if (gon.tran_types[id] === undefined) return

    const sources = gon.tran_types[id][`${type}s`] || []
    this.removeOptions(this[`${type}Sel`])

    sources.map(source => this.addOption(
      this[`${type}Sel`],
      source,
      source['id'] === gon.transaction[`${type}_account_id`]
    ))
  }

  removeOptions(selectElement) {
     var i, L = selectElement.options.length - 1

     for(i = L; i >= 1; i--) {
        selectElement.remove(i)
     }
  }

  addOption(sel, data, selected = false) {
    const opt = document.createElement('option')
    opt.value = data['id']
    opt.innerHTML = data['name']
    opt.selected = selected
    sel.appendChild(opt)
  }
}
