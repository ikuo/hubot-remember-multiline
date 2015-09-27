# Description
#   A hubot script to remember a key and value with one or more lines
#
# Commands:
#   hubot remember <key> is <value> - Write a key value pair to the brain.
#   hubot remember <key> - Show value for a key.
#   hubot forget <key> - Remove key from the brain.
#   hubot list remembered - Show all key value pairs.

_ = require('lodash')

module.exports = (robot) ->
  memories = () -> robot.brain.get('remember') ? {}

  get = (key) -> memories()?[key]

  set = (key, value) ->
    values = memories()
    values[key] = value
    robot.brain.set('remember', values)

  del = (key) ->
    values = memories()
    delete values[key]
    robot.brain.set('remember', values)

  robot.respond /list remembered/, (msg) ->
    text = _(memories())
      .map((value, key) -> "#{key}=#{_.trunc(value.replace("\n", '..'))}")
      .join("\n")
    msg.send text

  robot.respond /remember\s+(\w+)$/, (msg) ->
    key = msg.match[1]
    value = get(key)
    result = value || "I don't remember #{key}."
    msg.send result

  robot.respond /remember\s+(\w+)\s+is(?:\s|\n)((.|\n)+)$/, (msg) ->
    key = msg.match[1]
    value = msg.match[2]
    oldValue = get(key)
    set(key, value)
    if oldValue?
      msg.send "OK, I've forgotten the old value #{oldValue}."
    else
      msg.send 'OK'

  robot.respond /forget\s+(\w+)$/, (msg) ->
    key = msg.match[1]
    value = get(key)
    del(key)
    if value?
      msg.send "I've forgotten #{key} is #{value}."
    else
      msg.send "I've alredy forgotten #{key}."
