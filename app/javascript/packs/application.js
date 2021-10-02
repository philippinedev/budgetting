// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import TransactionForm from './transactions/form'
import { moneyFormat } from './shared/format'
import collapse        from './shared/collapse'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

const onLoad = () => {
  moneyFormat()

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

  for (let el of document.querySelectorAll('.tr-root, .tr-parent')) collapse(el)
}

window.addEventListener('turbolinks:load', () => onLoad())

