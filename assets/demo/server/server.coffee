express = require 'express'
path = require 'path'
app = express()

app.engine 'html', require('jade').renderFile

app.use '/static', express.static path.join __dirname, '..'
app.use '/imgs', express.static path.join __dirname, 'imgs'

console.log path.join __dirname, '..'

app.get '/', (req, res)->
  res.render 'index.jade'

app.listen 3000
console.log 'Listening on port 3000'