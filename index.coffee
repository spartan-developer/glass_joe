http = require 'http'
formidable = require 'formidable'
routing = require './routing'
routes = require './routes'
view_engine = require './view_engine'

router = new routing.Router()
routes.configure router

extract_params = (request, finished) ->
  if request.method == 'POST'
    new formidable.IncomingForm().parse request, (error, fields, files) ->
      request.method = fields._method if fields._method
      finished(error, fields, files)
  else
    finished(null, null, null)

server = http.createServer (request, response) ->
  extract_params request, (error, fields, files) ->
    route = router.route_for request
    if route
      viewEngine = view_engine.create_from(response)
      viewEngine.params = fields
      #route.tokens[0] =
        #render: (n, l) -> viewEngine.render n, l
        #params: fields
      view = route.action.apply(viewEngine, route.tokens.slice(1))
    else
      response.end 'Epic Fail!!!'

server.listen 8888

