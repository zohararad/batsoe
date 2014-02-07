class Batsoe.Post extends Batsoe.BaseModel
  @resourceName: 'posts'
  @storageKey: 'posts'

  @persist Batman.RailsStorage

  # Use @encode to tell batman.js which properties Rails will send back with its JSON.
  @encode 'id', 'title', 'slug', 'body'
  @encodeTimestamps()

