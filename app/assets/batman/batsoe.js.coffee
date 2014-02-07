#= require batman/es5-shim

#= require batman/batman
#= require batman/batman.rails

#= require batman/batman.jquery

#= require_self

#= require_tree ./lib
#= require_tree ./controllers
#= require_tree ./models
#= require_tree ./views

Batman.config.pathToHTML = '/assets/html'

class Batsoe extends Batman.App

  Batman.DOM.Yield.clearAllStale = -> {}

  # @resources 'products'
  # @resources 'discounts', except: ['edit']
  # @resources 'customers', only: ['new', 'show']

  # @resources 'blogs', ->
  #   @resources 'articles'

  # @resources 'pages', ->
  #   @collection 'count'
  #   @member 'duplicate'

  # @route 'apps', 'apps#index'
  # @route 'apps/private', 'apps#private', as: 'privateApps'

  @resources 'posts', only: ['index', 'show']
  @route 'posts/:id/:slug', 'posts#show', as: 'post_slug'
  @root 'posts#index', as: 'root'

(global ? window).Batsoe = Batsoe
