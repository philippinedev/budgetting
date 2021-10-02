const moneyFormat = (zeroAs = '-') => {
  document.querySelectorAll('.money').forEach(item => {
    if (item.innerText === '') return

    const value = parseFloat(item.innerText)
    if (isNaN(value)) return zeroAs

    item.innerText = value
      .toLocaleString('en-PH', {
        style: 'currency',
        currency: 'PHP'
      })
  })
}

export {
  moneyFormat
}
