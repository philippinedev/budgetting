export default element => {
  const handleClick = el => {
    const clickedTr = el.target.parentElement.parentElement

    const children = [...clickedTr.parentElement.children]
    const index    = children.indexOf(clickedTr)
    const tabNum   = +clickedTr.className.split(' ')[0]?.split('-').slice(-1)

    let items = []
    for (let child of children.filter(child => children.indexOf(child) > index)) {
      if (child.className === '') {
        items.push(child)
        continue
      }

      const diff = +child.className.split(' ')[0]?.split('-').slice(-1) - tabNum
      if (diff >= 20) items.push(child)
      if (diff === 0) break;
    }

    if (items.length === 0) return

    const display = items[0].style.display === 'none' ? 'table-row' : 'none'
    items.map(child => child.style.display = display)
  }

  element.addEventListener('click', handleClick)
}
