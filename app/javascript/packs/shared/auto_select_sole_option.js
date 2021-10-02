export default class AutoSelectSoleOption {
  constructor(selects) {
    this.selects = selects
    this.execute()
  }

  execute() {
    this.selects
      .filter(select => select.options[0].value === '')
      .filter(select => select.length === 2)
      .map(select => select.options[1].selected = 'selected')
  }
}
