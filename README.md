# hubot-remember-multiline

[![npm version](https://badge.fury.io/js/hubot-remember-multiline.svg)](http://badge.fury.io/js/hubot-remember-multiline)
[![Build Status](https://travis-ci.org/ikuo/hubot-remember-multiline.svg?branch=master)](https://travis-ci.org/ikuo/hubot-remember-multiline)

A hubot script to remember values with one or more lines.

See [`src/remember-multiline.coffee`](src/remember-multiline.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-remember-multiline --save`

Then add **hubot-remember-multiline** to your `external-scripts.json`:

```json
[
  "hubot-remember-multiline"
]
```

## Sample Interaction

```
user1>> hubot remember key1 is value1
hubot>> OK
user1>> hubot remember key1
hubot>> value1
```

See [./test/*.coffee](./test) for more examples.
