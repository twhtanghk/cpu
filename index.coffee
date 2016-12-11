Promise = require 'bluebird'
glob = Promise.promisify require 'glob'
path = require 'path'
fs = require 'fs'
_ = require 'lodash'
mqtt = require 'mqtt'
eventToPromise = require 'event-to-promise'

dir = path.dirname process.env.DEVICE

content = (file) ->
  fs.readFileSync(file, 'ascii').trim()
  
temp = ->
  glob process.env.DEVICE
    .map (file) ->
      path.basename(file).split('_')[0]
    .map (file) ->
      ret = {}
      label = content path.join(dir, "#{file}_label")
      input = parseInt(content(path.join(dir, "#{file}_input"))) / 1000
      ret[label] = input
      ret
    .reduce (res, temp) ->
      _.extend res, temp
    .then (temp) ->
      _.pick temp, 'CPUTIN', 'SYSTIN'

connect = (url) ->
  client = mqtt.connect url
  eventToPromise.multi client, ['connect'], ['reconnect', 'close', 'offline', 'error']
    .then ->
      return client

publish = (url, topic, msg, opts = {}) ->
  connect url
    .then (client) ->
      client.subscribe topic
      client.publish topic, msg, opts

pub = ->
  mqttpub = ->
    temp()
      .then (temp) ->
        publish process.env.URL, process.env.TOPIC, JSON.stringify temp
      .catch console.log

  setInterval mqttpub, process.env.INTERVAL

module.exports =
  temp: temp
  pub: pub
