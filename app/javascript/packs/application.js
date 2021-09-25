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
  const transactionForm = () => {
    Object.keys(gon).forEach(key => {
      document.getElementById(`transaction_${key}`).value = gon[key]
    })
  }

  const isTransactionNew  = !!document.querySelector('body.transactions-new')
  const isTransactionEdit = !!document.querySelector('body.transactions-edit')

  if (isTransactionNew || isTransactionEdit) {
    transactionForm()
  }
}

window.addEventListener('turbolinks:load', () => {
  onLoad()
  pageLoad()
})
window.addEventListener('load', () => {
  onLoad()
})

