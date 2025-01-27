const top = require('process-top')()
const StatsD = require('hot-shots')

function getStatsDPrefix() {
  const envVar = process.env.STATSD_PREFIX
  // trim leading and trailing dots
  const trimmedEnvVar = envVar?.replace(/^\.+|\.+$/g, '') ?? ''
  return trimmedEnvVar ? `nodemon.${trimmedEnvVar}.` : 'nodemon.'
}

const client = new StatsD({
  prefix: getStatsDPrefix(),
})

setInterval(function () {
  const cpu = top.cpu()
  const memory = top.memory()
  const delay = top.delay()
  client.increment('my_counter')
  client.gauge('cpu', cpu.percent)
  client.gauge('rss', memory.rss)
  client.gauge('heapTotal', memory.heapTotal)
  client.gauge('heapUsed', memory.heapUsed)
  client.gauge('total', memory.total)
  client.gauge('delay', delay)
}, 200).unref()
