# Description:
#   A hubot script to remember a key and value with one or more lines
#
# Configuration:
#   HUBOT_REMEMBER_MULTILINE_MAX_VALUE_CHARS_IN_LIST - default '120'
#   HUBOT_REMEMBER_MULTILINE_LINE_DELIMITER_IN_LIST - default '  '
#   HUBOT_REMEMBER_MULTILINE_KEY_VALUE_DELIMITER_IN_LIST - default "\t"
#
# Commands:
#   hubot remem[ber] <key> is <value> - Write a key value pair to the brain.
#   hubot remem[ber] <key> - Show value for a key.
#   hubot forget <key> - Remove key from the brain.
#   hubot list remem[bered] - Show all key value pairs.

_ = require('lodash')

config = require('hubot-config')('remember-multiline',
  maxValueCharsInList: '80',
  lineDelimiterInList: '  ',
  keyValueDelimiterInList: "\t"
)

config.maxValueCharsInList = Number(config.maxValueCharsInList)

KEY = '[\\w-]+'
REMEMBER = 'remem(?:ber)?'

module.exports = (robot) ->
  memories = () -> robot.brain.get('remember') ? {}
  newlines = /\n/g

  get = (key) -> memories()?[key]

  set = (key, value) ->
    values = memories()
    values[key] = value
    robot.brain.set('remember', values)

  del = (key) ->
    values = memories()
    delete values[key]
    robot.brain.set('remember', values)

  robot.respond ///list\s+#{REMEMBER}(ed)?///, (msg) ->
    msg.finish()
    text = _(memories())
      .map((value, key) ->
        value =
          value
            .replace(newlines, config.lineDelimiterInList)
            .replace('```', '') # remove block quote separators
        valueStr = _.trunc(value, length: config.maxValueCharsInList)
        "[#{key}]#{config.keyValueDelimiterInList}#{valueStr}"
      )
      .sort()
      .join("\n")
    msg.send text

  robot.respond ///#{REMEMBER}\s+(#{KEY})$///, (msg) ->
    msg.finish()
    key = msg.match[1]
    value = get(key)
    result = value || "I don't remember #{key}"
    msg.send result

  robot.respond ///#{REMEMBER}\s+(#{KEY})\s+is(?:\s|\n)((.|\n)+)$///, (msg) ->
    msg.finish()
    key = msg.match[1]
    value = msg.match[2]
    oldValue = get(key)
    set(key, value)
    if oldValue?
      msg.send "ok, and I've forgotten the old value #{oldValue}"
    else
      msg.send 'ok'

  robot.respond ///forget\s+(#{KEY})$///, (msg) ->
    msg.finish()
    key = msg.match[1]
    value = get(key)
    del(key)
    if value?
      msg.send "I've forgotten #{key} is #{value}"
    else
      msg.send "I've already forgotten #{key}"
