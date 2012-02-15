# Endless Reports

This library creates nifty-looking reports!  

To explain it, just assume a typical blog application - there are Authors (which have a first_name and last_name) and Posts (which have a title, a body, and an author).  

## The Simplest Possible Report

Ok, to start off, let's just create a basic report.  We're deliberately ignoring a lot of features here.  

### Define the report (in /app/models/all_posts_report.rb)
```ruby
class AllPostsReport < EndlessReports::Report
  
  define_columns do
    [
      {
        :key => "post_id", # TIP - keys can't be just "id", for compatibility with YUI
        :label => "ID",
        :data => :id
      },
      {:key => "title"}, # TIP - label and data will be guessed from the key
    ]
  end

  # Perform an ActiveRecord query, or whatever else gets you a collection.
  # Return value must respond to each
  def collection_for_report(offset=nil, limit=nil)
    Post.all(:select => "id, title", :offset => offset, :limit => limit)
  end

end
```

### Set up the controller to show the report (in /app/controllers/posts_controller.rb)
```ruby
class PostsController < ApplicationController
  include EndlessReportController
  endless_report :index, :with => AllPostsReport
end
````

### And we're done!

Wait, what?  What have we done?  

PostsController now has an "index" action, which uses the AllPostsReport to generate a report.  The HTML response for that action will include both markup and javascript to setup a YUI table.  The javascript calls the "index" action with a JS response type, querying for only the data necessary to show to the user.  See the "offset" and "limit" attributes in the collection_for_report method?  Those are used heavily - we only select enough data to fill the user's screen.  So even if we have a million Posts, we're only selecting them in small chunks.

This report isn't all that useful, yet.  To support more advanced features, like user-selected columns and conditionals, the AllPostsReport has to get a little more complicated.  