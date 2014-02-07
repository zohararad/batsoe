class Batsoe.PostsController extends Batsoe.ApplicationController
  routingKey: 'posts'

  index: (params) ->
    @set 'posts', Batsoe.Post.get('all')

  show: (params) ->
    Batsoe.Post.cachedFind params.id, (err, post) =>
      @set 'post', post