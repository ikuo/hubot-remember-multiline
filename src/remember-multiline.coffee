# Description
#   A hubot script to remember a key and value with one or more lines
#
# Commands:
#   hubot remember <key> is <value> - Add key and value to the brain.
#   hubot remember <key> - Show value for a key.
#   hubot forget <key> - Remove key from the brain.
#   hubot list remembered - Show all key value pairs.
#
# Author:
#   Ikuo Matsumura <makiczar@gmail.com>

module.exports = (robot) ->
  memories = () ->
    robot.brain.data.remember ?= {}

  robot.respond /remember\s+(\w+)$/, (res) ->
    key = res.match[1]
    value = memories()[key]
    result = value || "I don't remember `#{key}`"
    res.send result
