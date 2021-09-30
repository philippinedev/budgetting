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
  const initTransactionTypeSelector = () => {
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

    typeSel.addEventListener('change', el => {
      const sources = gon.tran_types[el.target.value].sources
      const targets = gon.tran_types[el.target.value].targets

      removeOptions(sourceSel)
      sources.map(source => addOption(sourceSel, source))

      removeOptions(targetSel)
      targets.map(source => addOption(targetSel, source))
    })
  }

  const isTransactionNew  = !!document.querySelector('body.transactions-new')
  const isTransactionEdit = !!document.querySelector('body.transactions-edit')

  if (isTransactionNew || isTransactionEdit) {
    initTransactionTypeSelector()
  }
}

window.addEventListener('turbolinks:load', () => {
  onLoad()
  pageLoad()
})

