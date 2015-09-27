expect = require('chai').use(require('chai-as-promised')).expect
hubot = require('hubot-mock-adapter-as-promised')

describe 'remember-multiline', ->
  hubot.includeContext ->
    robot.loadFile(require('path').resolve('.', 'src'), 'remember-multiline.coffee')

  context 'remember <key>', ->
    context 'with existent key', ->
      beforeEach ->
        robot.brain.data.remember = { key1: 'value1' }

      it 'shows the value', ->
        expect(hubot.text('hubot remember key1'))
          .to.eventually.equal("value1")

    context 'when non-existent key', ->
      beforeEach ->
        robot.brain.data.remember = undefined

      it 'notifies non-existent key', ->
        expect(hubot.text('hubot remember key1'))
          .to.eventually.equal("I don't remember `key1`")

  context 'remember <key> is <value>', ->
    context 'with existent key', ->
      beforeEach ->
        robot.brain.data.remember = { key1: 'value1' }

      it 'writes to the brain and shows old value', ->
        hubot.text('hubot remember key1 is value2').then (response) ->
          expect(response).to.match(/value1/)
          expect(robot.brain.data.remember).to.deep.equal(key1: 'value2')

    context 'when non-existent key', ->
      beforeEach ->
        robot.brain.data.remember = undefined

      it 'writes to the brain saying "ok"', ->
        hubot.text('hubot remember key1 is value1').then (response) ->
          expect(response).to.equal("ok")
          expect(robot.brain.data.remember).to.deep.equal(key1: 'value1')
