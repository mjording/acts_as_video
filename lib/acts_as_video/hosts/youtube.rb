module Youtube
  EMBED_ID_REGEX = /(http:\/\/)?(www.)?youtube\.com\/watch\?v=([A-Za-z0-9._%-]*)(\&\S+)?/
  
  def embed_url
    "http://www.youtube.com/oembed?url=http%3A//www.youtube.com/watch%3Fv%3D#{self.embed_id}&format=json"
  end
end