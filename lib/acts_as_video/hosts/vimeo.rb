module Vimeo
  EMBED_ID_REGEX = /(http:\/\/)?(www\.)?vimeo.com\/(\d+)($|\/)/
  
  def self.embed_url(id)
    "http://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/#{id}"
  end
end