# hubot-remember-multiline

A hubot script to remember a key and value with one or more lines.

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
user1>> hubot remember key1=value1
hubot>> OK
user1>> hubot remember key1
hubot>> value1
```

See [./test/*.coffee](./test) for more examples.
