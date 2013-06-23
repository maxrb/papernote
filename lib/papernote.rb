require "papernote/version"
require "papernote/formats/cornell"
require "papernote/formats/ruled"
require "papernote/formats/graph"

module Papernote
  def self.generate(format, options={})
    fmt_class=Kernel.const_get(format)
    fmt_instance=fmt_class.new(options)
    pdf = fmt_instance.make_page
    if(options[:o])
      pdf.render_file(options[:o])
    else
      print pdf.render
    end
  end
end
