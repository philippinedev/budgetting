const moneyFormat = () => {
  document.querySelectorAll('.money').forEach(item => {
    if (item.innerText === '') return

    item.innerText = parseFloat(item.innerText)
      .toLocaleString('en-PH', {
        style: 'currency',
        currency: 'PHP'
      })
  })
}

export {
  moneyFormat
}
