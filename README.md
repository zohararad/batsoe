# Batsoe

A dummy blog demonstrating how to create SEO-friendly single-page applications using Batman.js and Rails.

## Why Batsoe?

Because we shouldn't duplicate our views, install PhantomJS or break sweat when it comes to search-engine
optimisation of our single-page applications.

Ideally, we should use the same views on both the server (search-engine) and the browser. **right?**

### How is it done?

The principle is insanely simple, when you get your head around it.

Batman's templates are just plain-old HTML with some magic data attributes. That means they're perfect for both client
and server rendering. Normally, Batman templates don't contain any actual text, just markup with data attributes.

So, what if we were to do something like this:

1. Use ERB on the server-side, but add Batman-related data attributes to our markup. This will let use serve a normal HTML page for search engine.
2. Take the same ERB template, remove all ERB code, leaving just Batman's data-attribute, and provide these templates for Batman to render in the browser.

### Let's look at an example

Consider `app/assets/javascripts/batman/html/posts/index.html.erb`

```html
<h1 data-bind="post.title"><%= @post.title %></h1>
```

On the server, this is just a normal ERB template, with some Batman.js data attributes that the server doesn't care about.

In the browser, Batman will append the value of `post.title` as the text inside our `<h1>` tag, so we don't actually
need the ERB tag `<%= @post.title %>` (in fact, they're going to cause some errors, since ERB doesn't run in the browser).

Therefore, our modified template for Batman should look something like this:

```html
<h1 data-bind="post.title"></h1>
```

Same HTML, sans ERB. Simple, right?

### The code

#### Step 1 - ERB Templates

Since we'd like to share the same templates between server and browser, let's add Batman's template directory as part
of Rails view loopkup path.

Add this to your `config/application.rb`

```ruby
# add template dir to views path
config.paths['app/views'].unshift("#{Rails.root}/app/assets/batman/html")
```

Now Rails will look for views to render inside `app/assets/batman/html`

#### Step 2 - Cleanup ERB from Batman templates

We're going to write a view helper that will read all our ERB templates, remove the ERB tags and output the templates
HTML as a single JSON structured as `{"path/to/template":"template markup"}`

```ruby
module ApplicationHelper

  def batman_views_json
    prefix = Rails.root.join "app/assets/batman/html"
    paths = Dir.glob("#{prefix}/**/*").select{|f| File.file?(f) && (f =~ /\.(html|erb)$/i) }
    re = Regexp.new "<%(.*?)%>"
    paths.inject({}) do |all_views, f|
      viewname = f.sub( /^#{prefix}/, '' ).sub( /\..*$/i, '' )
      # this is where we clean our ERB tags
      view = File.read(f).gsub(re,'').gsub(/[\n\r]+/,'').gsub(/href=\"\"/,' ')
      view = ERB.new(view).result if f =~ /\.erb$/i
      all_views[viewname] = view.gsub(/[\r\n\t]+|\s{2}/,'')
      all_views
    end.to_json
  end

end
```

The code above is a modified version of the code found in [Batman's Secret Cache](http://www.rigelgroupllc.com/blog/2012/02/01/batmans-secret-cache/) post

The reason we're using a view helper, rather than an ERB Javascript (as per original code in Batman's Secret Cache), is that
using the latter technique won't detect changes made to the templates between reloads. Using a view helper, and outputting
the templates HTML into our layout solves that, and has the added benefit of having all the template HTML when the page loads.

In our layout file `app/views/layout.html.erb` we add:

```html
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

Finally, we need to modify `config/application.rb` and make sure our ERB templates are excluded from the Asset Pipeline:

```ruby
config.assets.precompile = [ Proc.new { |path, fn|
  fn =~ /app\/assets/ && !%w(.js .css .html).include?(File.extname(path)) },
  /application.(css|js)$/
]
```

And that's it... Your Rails app now shares its views between the server and the client.

### What's next?

* Check out `app/controllers/application_controller.rb` for an example of search engine detection
* Check out `app/views/layout.html.erb` to see how to selectively initialize the Batman app for non search-engine requests
* Check out `app/assets/batman` for the actual Batman.js code (although I warn you - it's pretty basic)
* Spread the word