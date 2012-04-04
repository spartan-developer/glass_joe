_ = require 'underscore'

class Route
  constructor: (method, template_string, action) ->
    @method = method.toUpperCase()
    @template = new RegExp(template_string.replace /\$/g, '(.+)')
    @action = action
  matches: (request) ->
    (@tokens = request.url.match(@template)) and request.method == @method

class Router
  constructor: -> @routes = []
  get: (template_string, action) -> @routes.push new Route('GET', template_string, action)
  post: (template_string, action) -> @routes.push new Route('POST', template_string, action)
  delete: (template_string, action) -> @routes.push new Route('DELETE', template_string, action)
  route_for: (request) -> _.find @routes, (route) -> route.matches request

exports.Router = Router
