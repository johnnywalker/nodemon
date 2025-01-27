#!/usr/bin/env node

const { spawn } = require('child_process')
const { join } = require('path')

function printUsage() {
  console.log('Usage: node-monitor [options] <script> [script-args]')
  console.log('Options:')
  console.log('  --statsd-prefix, -p <prefix>  Set the statsd prefix')
}

function parseArgs() {
  const args = process.argv.slice(2)
  if (args.length === 0) {
    printUsage()
    process.exit(1)
  }
  if (args[0] === '--help' || args[0] === '-h') {
    printUsage()
    process.exit(0)
  }

  // check if the first argument is a flag to set the statsd prefix
  if (args[0] === '--statsd-prefix' || args[0] === '-p') {
    return {
      statsdPrefix: args[1],
      restArgs: args.slice(2),
    }
  }
  return {
    statsdPrefix: null,
    restArgs: args,
  }
}

const { statsdPrefix, restArgs } = parseArgs()
if (statsdPrefix) {
  process.env.STATSD_PREFIX = statsdPrefix
}

spawn(process.execPath, ['-r', join(__dirname, 'monitor.js')].concat(restArgs), {
  stdio: 'inherit',
})
