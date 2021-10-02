export default class AddSelectionPrompt {
  constructor(select, selectInstruction = "Select...") {
    this.select = select
    this.selectInstruction = selectInstruction
    this.execute()
  }

  execute() {
    if (this.select.options[0].value === '') return

    const opt = document.createElement('option')
    opt.value = ''
    opt.innerHTML = this.selectInstruction
    this.select.prepend(opt)
  }
}
