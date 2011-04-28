module Youtube
  EMBED_ID_REGEX = /(http:\/\/)?(www.)?youtube\.com\/watch\?v=([A-Za-z0-9._%-]*)(\&\S+)?/
  
  def self.embed_url(id)
    "http://www.youtube.com/oembed?url=http%3A//www.youtube.com/watch%3Fv%3D#{id}&format=json"
  end
end