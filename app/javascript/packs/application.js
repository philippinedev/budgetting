// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import TransactionForm from './transactions/form'

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
  const isTransactionForm = () => {
    return !!document.querySelector('body.transactions-new')
      || !!document.querySelector('body.transactions-edit')
      || !!document.querySelector('body.transactions-create')
      || !!document.querySelector('body.transactions-update')
  }

  if (isTransactionForm()) {
    if (gon.tran_types === undefined) {
      console.error("Error: gon.tran_types is undefined.")
      return
    }

    new TransactionForm()
  }
}

window.addEventListener('turbolinks:load', () => {
  onLoad()
  pageLoad()
})

