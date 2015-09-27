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
  memories = () ->
    robot.brain.data.remember ?= {}

  robot.respond /list remembered/, (msg) ->
    text = _(memories()).map((value, key) -> "#{key}=#{value}").join("\n")
    msg.send text

  robot.respond /remember\s+(\w+)$/, (msg) ->
    key = msg.match[1]
    value = memories()[key]
    result = value || "I don't remember #{key}."
    msg.send result

  robot.respond /remember\s+(\w+)\s+is\s(.+)$/, (msg) ->
    key = msg.match[1]
    value = msg.match[2]
    oldValue = memories()[key]
    memories()[key] = value
    if oldValue?
      msg.send "OK, I've forgotten the old value #{oldValue}."
    else
      msg.send 'OK'

  robot.respond /forget\s+(\w+)$/, (msg) ->
    key = msg.match[1]
    value = memories()[key]
    delete memories()[key]
    if value?
      msg.send "I've forgotten #{key} is #{value}."
    else
      msg.send "I've alredy forgotten #{key}."
