module Vimeo
  EMBED_ID_REGEX = /(http:\/\/)?(www\.)?vimeo.com\/(\d+)($|\/)/
  
  def embed_url
    "http://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/#{self.embed_id}"
  end
end