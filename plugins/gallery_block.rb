module Jekyll

  class GalleryBlock < Liquid::Block
    @gallery = nil

    def initialize(tag_name, markup, tokens)
      @markup = markup
      super
    end

    def render(context)
      id = "gallery"
      id << "-#{@markup}" unless @markup.empty?
      %{<div id=#{id}> <div class="gallery-row"> #{super} </div> </div>}
    end
  end

  class GalleryTag < Liquid::Tag
    @img = nil

    def initialize(tag_name, markup, tokens)
      attributes = ['class', 'src', 'width', 'height', 'title']

      if markup =~ /(?<class>\S.*\s+)?(?<src>(?:https?:\/\/|\/|\S+\/)\S+)(?:\s+(?<width>\d+))?(?:\s+(?<height>\d+))?(?<title>\s+.+)?/i
        @img = attributes.reduce({}) { |img, attr| img[attr] = $~[attr].strip if $~[attr]; img }
        if /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ @img['title']
          @img['title']  = title
          @img['alt']    = alt
        else
          @img['alt']    = @img['title'].gsub!(/"/, '&#34;') if @img['title']
        end
        @img['class'].gsub!(/"/, '') if @img['class']
      end
      super
    end

    def render(context)
      if @img
        %{<a href='#{@img["src"]}' data-ngthumb="#{@img["src"]}" >#{@img["title"]}</a>}
      else
        "Error processing input, expected syntax: {% img [class name(s)] [http[s]:/]/path/to/image [width [height]] [title text | \"title text\" [\"alt text\"]] %}"
        end
    end
  end
end

Liquid::Template.register_tag('gallery', Jekyll::GalleryBlock)
Liquid::Template.register_tag('galleryitem', Jekyll::GalleryTag)
