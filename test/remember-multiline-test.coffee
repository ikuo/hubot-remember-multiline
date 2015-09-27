expect = require('chai').use(require('chai-as-promised')).expect
hubot = require('hubot-mock-adapter-as-promised')

describe 'remember-multiline', ->
  hubot.includeContext ->
    robot.loadFile(require('path').resolve('.', 'src'), 'remember-multiline.coffee')

  context 'remember <key>', ->
    context 'when key exists', ->
      beforeEach ->
        robot.brain.data.remember = { key1: 'value1' }

      it 'shows the value', ->
        expect(hubot.text('hubot remember key1'))
          .to.eventually.match(/value1/)

    context 'when key does not exist', ->
      it 'notifies non-existent key', ->
        expect(hubot.text('hubot remember key1'))
          .to.eventually.match(/I don't remember `key1`/)

  #context 'remember <key> is <value>', ->
