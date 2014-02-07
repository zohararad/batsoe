# Batsoe

A dummy blog demonstrating how to create SEO-friendly single-page applications using Batman.js and Rails.

## Why Batsoe?

Because we shouldn't duplicate our views, install PhantomJS or break sweat when it comes to search-engine
optimisation of our single-page applications.

Ideally, we should use the same views on both the server (search-engine) and the browser. **right?**

### How is it done?

The principle is insanely simple, when you get your head around it.

Batman's templates are just plain-old HTML with some magic data attributes. That means they're perfect for both client
and server rendering. Batman templates don't actually contain any text, just markup with data attributes.

So, what if we were to do something like this:

1. Use ERB on server side to render a Batman HTML template with SEO content (as one normally does on multi-page sites)
2. Clean up ERB from the same HTML templates, leaving Batman's data attributes and use them with Batman

### Let's look at an example

Consider `app/assets/javascripts/batman/html/posts/index.html.erb`

```html
<h1 data-bind="post.title"><%= @post.title %></h1>
```

On the server, this is just a normal ERB template, with some Batman.js data attributes that the server doesn't care about.

In the browser, Batman will append the value of `post.title` as the text inside our `<h1>` tag, so we don't actually
need the ERB tags `<%= @post.title %>` (in fact, they're going to cause some errors, since ERB doesn't run in the browser).

Therefore, our modified template for Batman will look something like this:

```html
<h1 data-bind="post.title"></h1>
```

Same HTML, sans ERB. Simple, right?

### The code

Here's how we take a normal ERB template, and clean it up, making it safe for Batman to consume.

```ruby
module ApplicationHelper

  def batman_views_json
    prefix = Rails.root.join "app/assets/batman/html"
    paths = Dir.glob("#{prefix}/**/*").select{|f| File.file?(f) && (f =~ /\.(html|erb)$/i) }
    re = Regexp.new "<%(.*?)%>"
    paths.inject({}) do |all_views, f|
      viewname = f.sub( /^#{prefix}/, '' ).sub( /\..*$/i, '' )
      view = File.read(f).gsub(re,'').gsub(/[\n\r]+/,'').gsub(/href=\"\"/,' ') # this is where we clean our ERB tags
      view = ERB.new(view).result if f =~ /\.erb$/i
      all_views[viewname] = view.gsub(/[\r\n\t]+|\s{2}/,'')
      all_views
    end.to_json
  end

end
```

The code above is a modified version of the code found in [Batman's Secret Cache](http://www.rigelgroupllc.com/blog/2012/02/01/batmans-secret-cache/) post

Now, all we need to do is pre-populate Batman's view cache with our parsed HTML template code:

`app/views/layout.html.erb`

```erb
<script type="text/javascript">
  (function(){
    var cachedTemplates = <%= raw batman_views_json %>

    for(var view in cachedTemplates){
      if(cachedTemplates.hasOwnProperty(view)){
        Batman.View.store.set(view, cachedTemplates[view])
      }
    }
  }());
</script>
```

Finally, we need to make sure our ERB templates are excluded from the Asset Pipeline, but are included in Rails view path:

`config/application.rb`

```ruby
# add template dir to views path
config.paths['app/views'].unshift("#{Rails.root}/app/assets/batman/html")
# exclude HTML files from the precompile list of the asset pipeline
config.assets.precompile = [ Proc.new { |path, fn|
  fn =~ /app\/assets/ && !%w(.js .css .html).include?(File.extname(path)) },
  /application.(css|js)$/
]
```

And that's it... Your Rails app now shares its views between the server and the client.