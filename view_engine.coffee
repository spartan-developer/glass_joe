fs = require 'fs'
compile = require 'ruby-haml'

class ViewEngine
  constructor: (@response) ->
  render: (name, locals) ->
    response = @response
    fs.readFile "views/#{name}.html.haml", (err, haml) ->
      compile haml.toString(), locals, (error, output) ->
        content = output
        fs.readFile "views/layout.html.haml", (err, haml) ->
          compile haml.toString(), { content: content }, (err, output) ->
            response.end output

exports.create_from = (response) -> new ViewEngine(response)
