expect = require('chai').use(require('chai-as-promised')).expect
hubot = require('hubot-mock-adapter-as-promised')

describe 'remember-multiline', ->
  hubot.includeContext ->
    robot.loadFile(require('path').resolve('.', 'src'), 'remember-multiline.coffee')

  context 'remember <key>', ->
    context 'with existent key', ->
      context 'with single-line value', ->
        beforeEach -> robot.brain.set('remember', key1: 'value1')
        it 'shows the value', ->
          expect(hubot.text('hubot remember key1'))
            .to.eventually.equal("value1")

        it 'shows the value by abbreviated form', ->
          expect(hubot.text('hubot remem key1'))
            .to.eventually.equal("value1")

      context 'with multi-line value', ->
        beforeEach -> robot.brain.set('remember', key1: "value1a\nvalue1b")
        it 'shows the value', ->
          expect(hubot.text('hubot remember key1'))
            .to.eventually.equal("value1a\nvalue1b")

      context 'with hyphen', ->
        beforeEach -> robot.brain.set('remember', 'key-hyphen': 'value1')
        it 'shows the value', ->
          expect(hubot.text('hubot remember key-hyphen'))
            .to.eventually.equal("value1")

    context 'with non-existent key', ->
      beforeEach -> robot.brain.remove('remember')

      it 'notifies non-existent key', ->
        expect(hubot.text('hubot remember key1'))
          .to.eventually.equal("I don't remember key1")

  context 'remember <key> is <value>', ->
    context 'with existent key', ->
      beforeEach -> robot.brain.set('remember', key1: 'value1')

      it 'writes to the brain and shows the old value', ->
        hubot.text('hubot remember key1 is value2').then (response) ->
          expect(response).to.match(/value1/)
          expect(robot.brain.get('remember')).to.deep.equal(key1: 'value2')

    context 'with non-existent key', ->
      beforeEach -> robot.brain.remove('remember')

      context 'with single-line value', ->
        it 'writes to the brain saying "OK"', ->
          hubot.text('hubot remember key1 is value1').then (response) ->
            expect(response).to.match(/ok/i)
            expect(robot.brain.get('remember')).to.deep.equal(key1: 'value1')

      context 'with multi-line value', ->
        it 'writes to the brain saying "OK"', ->
          hubot.text('hubot remember key1 is\nvalue1a\nvalue1b').then (response) ->
            expect(response).to.match(/ok/i)
            expect(robot.brain.get('remember')).to.deep.equal(key1: 'value1a\nvalue1b')

  context 'forget <key>', ->
    beforeEach -> robot.brain.set('remember', key1: 'value1', key2: 'value2')

    context 'with existent key without any special char', ->
      it 'removes the key from the brain', ->
        hubot.text('hubot forget key1').then (response) ->
          expect(response).to.equal("I've forgotten key1 is value1")
          expect(robot.brain.get('remember')).to.deep.equal(key2: 'value2')

    context 'with non-existent key', ->
      it 'notifies non-existent key', ->
        hubot.text('hubot forget key0').then (response) ->
          expect(response).to.equal("I've already forgotten key0")
          expect(robot.brain.get('remember')).to.deep.equal(key1: 'value1', key2: 'value2')

    context 'with existent key with hyphen', ->
      beforeEach -> robot.brain.set('remember', 'key-hyphen': 'value1', key2: 'value2')
      it 'removes the key from the brain', ->
        hubot.text('hubot forget key-hyphen').then (response) ->
          expect(response).to.equal("I've forgotten key-hyphen is value1")
          expect(robot.brain.get('remember')).to.deep.equal(key2: 'value2')


  context 'list remembered', ->
    context 'with existent key', ->
      context 'when short values', ->
        beforeEach -> robot.brain.set 'remember',
          key1: "value1"
          key2: "value2"
          key3: "value3a\nvalue3b"

        it 'shows all key value pairs', ->
          hubot.text('hubot list remembered').then (response) ->
            expect(response).to.match(/\[key1\]\tvalue1/)
            expect(response).to.match(/\[key2\]\tvalue2/)
            expect(response).to.match(/\[key3\]\tvalue3a/)

        it 'shows multiline values in single line', ->
          hubot.text('hubot list remembered').then (response) ->
            expect(response).to.match(/\[key3\]\tvalue3a  value3b/)

        it 'responds by abbreviated messages', ->
          hubot.text('hubot list remem').then (response) ->
            expect(response).to.match(/\[key1\]\tvalue1/)

      context 'when long values', ->
        beforeEach -> robot.brain.set 'remember',
          key3: "value3a\nvalue3b long long long long text\nlong long"

        context 'when default setting', ->
          it 'shows value truncated with 80 chars', ->
            hubot.text('hubot list remembered').then (response) ->
              expect(response).to.match(/\[key3\]\tvalue3a  value3b long long long long text  long long$/)
