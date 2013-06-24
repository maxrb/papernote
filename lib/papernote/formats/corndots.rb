#encoding: utf-8

require 'prawn'
require 'prawn/measurement_extensions'
require 'methadone'

class Corndots
  include Methadone::CLILogging

  def initialize(options={})
    @pdf = Prawn::Document.new
    @pdf.line_width = 0.25.mm
    (@width, @height) = @pdf.page.dimensions[2,3]
    debug("Dimensions are W: #{@width}, H: #{@height}")
    @options = {
      spacing: 15,
      color: "BEBEBE",
      header_height: 12.mm,
      header_date_width: 35.mm,
      element_margin: 2.mm,
      side_bar_width: 40.mm
    }.merge(options)

  end

  def make_page
    draw_header
    draw_left_sidebar
    draw_body
    draw_footer
    @pdf
  end

  def draw_header
    @pdf.stroke_color = "ABABAB"

    # Draw title area
    @pdf.bounding_box([0,@pdf.margin_box.height], :width => @pdf.margin_box.width - @options[:element_margin] - @options[:header_date_width], :height => @options[:header_height]) do
      @pdf.stroke_bounds
    end

    # Draw date area
    @pdf.bounding_box([@pdf.margin_box.width - @options[:header_date_width], @pdf.margin_box.height], :width => @options[:header_date_width], :height => @options[:header_height]) do
      @pdf.stroke_bounds
    end
  end

  def draw_left_sidebar

    @pdf.stroke_color = "ABABAB"

    @pdf.bounding_box([0,@pdf.margin_box.height - @options[:header_height] - @options[:element_margin]], :width => @options[:side_bar_width], :height => @pdf.margin_box.height - @options[:header_height] - @options[:element_margin]) do
      @pdf.stroke_bounds
    end

  end

  def draw_body
    puts "Width x Height = #{@pdf.bounds.width} x #{@pdf.bounds.height}"
    @pdf.bounding_box([ @options[:side_bar_width] +  @options[:element_margin],@pdf.margin_box.height - @options[:header_height] - @options[:element_margin]], :width => @pdf.margin_box.width - @options[:side_bar_width] - @options[:element_margin], :height => @pdf.margin_box.height - @options[:header_height] - @options[:element_margin]) do
      @pdf.stroke_color = @options[:color]
      @pdf.stroke do
        x = @options[:spacing]
        while (x + @options[:spacing] < @pdf.bounds.width) do
          y = @pdf.bounds.height - @options[:spacing]
          while (y - @options[:spacing] > 0) do
            @pdf.circle [x,y], 0.1.mm
            y -= @options[:spacing]
          end
          x += @options[:spacing]
        end

      end

      @pdf.stroke_color = "ABABAB"
      @pdf.stroke_bounds
    end
  end

  def draw_footer
    @pdf.float do
      @pdf.move_down 15.mm
      @pdf.bounding_box([@pdf.margin_box.absolute_right - 24.mm, @pdf.margin_box.absolute_bottom - 4.mm], :width => 40.mm) do
        texts = [{ :text => "bam", :font => 'Helvetica', :size => 10, :color=>"AAAAAA" }]
        text_box = Prawn::Text::Formatted::Box.new(texts, :document => @pdf, :width => @pdf.width_of("© 12G Solutions"))
        text_box.render
      end
    end
  end
end
