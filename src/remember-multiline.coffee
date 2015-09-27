# Description
#   A hubot script to remember a key and value with one or more lines
#
# Commands:
#   hubot remember <key> is <value> - Write a key value pair to the brain.
#   hubot remember <key> - Show value for a key.
#   hubot forget <key> - Remove key from the brain.
#   hubot list remembered - Show all key value pairs.

module.exports = (robot) ->
  memories = () ->
    robot.brain.data.remember ?= {}

  robot.respond /remember\s+(\w+)$/, (res) ->
    key = res.match[1]
    value = memories()[key]
    result = value || "I don't remember #{key}."
    res.send result

  robot.respond /remember\s+(\w+)\s+is\s(.+)$/, (res) ->
    key = res.match[1]
    value = res.match[2]
    oldValue = memories()[key]
    memories()[key] = value
    if oldValue?
      res.send "OK, I've forgotten the old value #{oldValue}."
    else
      res.send 'OK'

  robot.respond /forget\s+(\w+)$/, (res) ->
    key = res.match[1]
    value = memories()[key]
    delete memories()[key]
    if value?
      res.send "I've forgotten #{key} is #{value}."
    else
      res.send "I've alredy forgotten #{key}."
