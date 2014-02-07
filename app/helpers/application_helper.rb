module ApplicationHelper

  def batman_views_json
    prefix = Rails.root.join "app/assets/batman/html"
    paths = Dir.glob("#{prefix}/**/*").select{|f| File.file?(f) && (f =~ /\.(html|erb)$/i) }
    re = Regexp.new "<%(.*?)%>"
    paths.inject({}) do |all_views, f|
      viewname = f.sub( /^#{prefix}/, '' ).sub( /\..*$/i, '' )
      view = File.read(f).gsub(re,'').gsub(/[\n\r]+/,'').gsub(/href=\"\"/,' ')
      view = ERB.new(view).result if f =~ /\.erb$/i
      all_views[viewname] = view.gsub(/[\r\n\t]+|\s{2}/,'')
      all_views
    end.to_json
  end

end
