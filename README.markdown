acts as video
=============
Create, Store, and Embed videos from different Oembed host using their url

* Vimeo
* Youtube

Usage
----
Create a model to use as a video and setup migration

    create_table :videos, :force => true do |t|
      t.column :title, :string
      t.column :embed_id, :string
      t.column :host, :string
      t.column :thumbnail_url, :string
    end  

To allow both vimeo and youtube videos

    class Video < ActiveRecord::Base
      acts_as_video
    end

To allow only vimeo videos

    class Video < ActiveRecord::Base
      acts_as_video :video_hosts => [:vimeo]
    end

Then create a model

    video = Video.new :url => 'http://vimeo.com/15556095'

Acts as video will store the title, and thumbnail id. It also makes it easy to get the current embed code
    
    video.title                   #=> 'Globe - 2010 Imaginarium - Ungu [magenta]'
    video.thumbnail_url           #=> "http:\/\/b.vimeocdn.com\/ts\/939\/007\/93900786_640.jpg'
    video.embed_code              #=> '<iframe src="http:\/\/player.vimeo.com\/video\/15556095" width="720" height="405" frameborder="0"><\/iframe>'
    #embed_code(maxwidth, maxheight)
    video.embed_code(200, 200)    #=> '<iframe src="http:\/\/player.vimeo.com\/video\/15556095" width="200" height="113" frameborder="0"><\/iframe>'
Contributing to acts as video
----- 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright

Copyright (c) 2011 anark.

