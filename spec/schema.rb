ActiveRecord::Schema.define :version => 0 do  
  create_table :videos, :force => true do |t|
    t.column :title, :string
    t.column :embed_id, :string
    t.column :type, :string
    t.column :thumbnail_url, :string
  end  

  create_table :vimeo_videos, :force => true do |t|
    t.column :title, :string
    t.column :embed_id, :string
    t.column :type, :string
    t.column :thumbnail_url, :string
  end  
end