// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

const pageLoad = () => {
  const moneyFormat = () => {
    document.querySelectorAll('.money').forEach(item => {
      item.innerText = parseFloat(item.innerText)
        .toLocaleString('en-PH', {
          style: 'currency',
          currency: 'PHP'
        })
    })
  }

  moneyFormat()
}

const onLoad = () => {
  const typeSel = document.getElementById('transaction_transaction_type_id')
  const sourceSel = document.getElementById('transaction_source_account_id')
  const targetSel = document.getElementById('transaction_target_account_id')

  const removeOptions = selectElement => {
     var i, L = selectElement.options.length - 1

     for(i = L; i >= 1; i--) {
        selectElement.remove(i)
     }
  }

  const addOption = (sel, data) => {
    const opt = document.createElement('option')
    opt.value = data['id']
    opt.innerHTML = data['name']
    sel.appendChild(opt)
  }

  const onTransactionTypeChange = id => {
    const sources = gon.tran_types[id]?.sources || []
    const targets = gon.tran_types[id]?.targets || []

    removeOptions(sourceSel)
    sources.map(source => addOption(sourceSel, source))

    removeOptions(targetSel)
    targets.map(source => addOption(targetSel, source))
  }

  const initTransactionTypeSelector = () => {
    typeSel.addEventListener('change', el => {
      onTransactionTypeChange(el.target.value)
    })
  }

  const isTransactionNew    = !!document.querySelector('body.transactions-new')
  const isTransactionEdit   = !!document.querySelector('body.transactions-edit')
  const isTransactionCreate = !!document.querySelector('body.transactions-create')
  const isTransactionUpdate = !!document.querySelector('body.transactions-update')

  const isTransactionForm = (
    isTransactionNew
    || isTransactionEdit
    || isTransactionCreate
    || isTransactionUpdate
  )

  if (isTransactionForm) {
    initTransactionTypeSelector()
    onTransactionTypeChange(typeSel.value)
  }
}

window.addEventListener('turbolinks:load', () => {
  onLoad()
  pageLoad()
})

