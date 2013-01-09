require "papernote/version"
require "papernote/formats/cornell"

module Papernote
  def self.generate(format, options={})
    fmt_class=Kernel.const_get(format)
    fmt_instance=fmt_class.new(options)
  end
end
