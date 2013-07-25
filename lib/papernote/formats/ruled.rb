#encoding: utf-8

require 'prawn'
require 'prawn/measurement_extensions'
require 'methadone'

class Ruled
  include Methadone::CLILogging

  def initialize(options={})
    @pdf = Prawn::Document.new
    @pdf.line_width = 0.25.mm
    (@width, @height) = @pdf.page.dimensions[2,3]
    debug("Dimensions are W: #{@width}, H: #{@height}")
    @options = { area: :graph, spacing: 16.12, color: "d8d8d8" }.merge(options)
  end

  def make_page
    draw_header
    draw_body
    draw_footer
    @pdf
  end

  def draw_header
    @pdf.stroke_color = "ABABAB"

    # Draw title area
    @pdf.bounding_box([0,@pdf.margin_box.height], :width => @pdf.margin_box.width - 37.mm, :height => 12.mm) do
      @pdf.stroke_bounds
    end

    # Draw date area
    @pdf.bounding_box([@pdf.margin_box.width - 35.mm,@pdf.margin_box.height], :width => 35.mm, :height => 12.mm) do
      @pdf.stroke_bounds
    end
  end

  def draw_body
    @pdf.bounding_box([0,@pdf.margin_box.height - 14.mm], :width => @pdf.margin_box.width, :height => @pdf.margin_box.height - 25.mm) do
      @pdf.stroke_color = @options[:color]
      @pdf.stroke do

        @pdf.y -= @options[:spacing]
        while (@pdf.y - (@options[:spacing] * 1.5) > @pdf.bounds.absolute_bottom) do
          @pdf.horizontal_rule
          @pdf.y -= @options[:spacing]
        end
      end

      @pdf.stroke_color = "ABABAB"
      @pdf.stroke_bounds
    end
  end

  def draw_footer
    @pdf.float do
      @pdf.move_down 15.mm
      @pdf.bounding_box([@pdf.margin_box.absolute_right - 40.mm, @pdf.margin_box.absolute_bottom - 5.mm], :width => 40.mm) do
        texts = [{ :text => "© 12G Solutions", :font => 'Helvetica', :size => 10, :color=>"666666" }]
        text_box = Prawn::Text::Formatted::Box.new(texts, :document => @pdf, :width => @pdf.width_of("© 12G Solutions"))
        text_box.render
      end
    end
  end
end
