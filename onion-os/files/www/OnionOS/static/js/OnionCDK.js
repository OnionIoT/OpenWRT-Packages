var OnionCDK = {
  appUid: '',
  makeId: function () {
    return Math.random().toString(36).substring(2)
  },
  init: function () {
    window.addEventListener('message', this.processMessage.bind(this), false)
  },
  subscribe: function (topic) {
    this.sendEvent('Onion.CDK.Subscribe', {topic: topic})
  },
  publish: function (topic, content) {

  },
  service: function (name, command, callback) {
    this.sendEvent('Onion.CDK.Service', {
      service: name,
      command: command
    })
  },
  sendEvent: function (event, content) {
    var eventId = this.makeId()
    window.parent.postMessage({
      event: event,
      instance: this.appUid,
      eventId: eventId,
      content: content
    }, '*')
    return eventId
  },
  sendCmd: function (command, params) {
    this.sendEvent('Onion.CDK.Command', {
      cmd: command,
      params: params
    })
  },
  sendToast: function (message) {
    this.sendEvent('Onion.CDK.Toast', {
      message: message
    })
  },
  processMessage: function (e) {
    console.log(e)
    if (e.data.event === 'Onion.CDK.Init') {
      var appUid = e.data.appUid
      this.appUid = appUid
      this.onInit()
      console.log('Onion.CDK.Init')
      console.log(this)
    } else if (e.data.event === 'Onion.CDK.Service') {
      this.onService(
        e.data.content.name,
        e.data.content.command,
        e.data.content.result)
    } else if (e.data.event === 'Onion.CDK.Message') {
      this.onMessage(
        e.data.content.topic,
        e.data.content.content)
    } else if (e.data.event === 'Onion.CDK.Command') {
      this.onCmd(
        e.data.content.cmd,
        e.data.content.resp)
    }
  },
  onInit () {},
  onService (name, command, result) {},
  onMessage (topic, content) {},
  onCmd (command, result) {}
}
