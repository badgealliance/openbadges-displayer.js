express = require 'express'
path = require 'path'
app = express()

app.use '/', express.static path.join __dirname, 'public'
app.use '/static', express.static path.join __dirname, '..'
app.use '/js', express.static path.join __dirname, '..'
app.use '/imgs', express.static path.join __dirname, 'public'

app.listen 3000
console.log 'Listening on port 3000'