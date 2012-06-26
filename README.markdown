# Endless Collections

** Endless Collections is still undergoing heavy development and is considered incomplete. **

This library creates nifty-looking tables!  

To explain it, just assume a typical blog application - there are Authors (which have a first_name and last_name) and Posts (which have a title, a body, and an author).  

## The Simplest Possible Collection

Ok, to start off, let's just create a basic collection.  We're deliberately ignoring a lot of features here.  

### Define the collection (in /app/models/all_posts_collection.rb)
```ruby
class AllPostsCollection < EndlessCollections::Collection
  
  # Perform an ActiveRecord query, or whatever else gets you a collection.
  # Return value must respond to each.  
  def fetch_collection_data(offset=nil, limit=nil)
    Post.all(:select => "id, title", :offset => offset, :limit => limit)
  end

  # The total number of results in the collection
  def total_results
    Post.count
  end

end
```

### Set up the controller to show the collection (in /app/controllers/posts_controller.rb)
```ruby
class PostsController < ApplicationController
  include EndlessCollections::EndlessCollectionController
  endless_collection :index, :with => AllPostsCollection
end
```

### And we're done!

Wait, what?  What have we done?  

PostsController now has an "index" action, which uses the AllPostsReport to generate a collection.  The javascript calls the "index" action with a JS response type, querying for only the data necessary to show to the user.  See the "offset" and "limit" attributes in the fetch_collection_data method?  Those are used heavily - we only select enough data to fill the user's screen.  So even if we have a million Posts, we're only selecting them in small chunks.

This colllection isn't all that useful, yet.  To support more advanced features, like user-selected columns and conditionals, the AllPostsCollection has to get a little more complicated.  To display the table, you will need to include a JavaScript display mechanism, which will be released in a separate repository.

## Other features

TODO: Link these to more extensive documentation!

* Place the collection table inside your custom views
* Sortable columns
* Filterable columns - allow your users to filter the collections
* Client-side formatting with JS formatters

## License

TODO: license