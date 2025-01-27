const top = require('process-top')()
const StatsD = require('hot-shots')

const client = new StatsD({
  globalTags: { env: process.env.NODE_ENV },
})

setInterval(function () {
  const cpu = top.cpu()
  const memory = top.memory()
  const delay = top.delay()
  client.gauge('cpu', cpu.percent)
  client.gauge('rss', memory.rss)
  client.gauge('heapTotal', memory.heapTotal)
  client.gauge('heapUsed', memory.heapUsed)
  client.gauge('total', memory.total)
  client.gauge('delay', delay)
}, 1000).unref()
