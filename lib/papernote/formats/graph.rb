#encoding: utf-8

require 'prawn'
require 'prawn/measurement_extensions'
require 'methadone'

class Graph
  include Methadone::CLILogging

  def initialize(options={})
    @pdf = Prawn::Document.new
    @pdf.line_width = 0.25.mm
    (@width, @height) = @pdf.page.dimensions[2,3]
    debug("Dimensions are W: #{@width}, H: #{@height}")
    @options = { area: :graph, spacing: 15, color: "e3f4f8" }.merge(options)
  end

  def make_page
    draw_header
    draw_body
    draw_footer
    @pdf
  end

  def draw_header
    @pdf.stroke_color = "e3f4f8"

    y = @pdf.margin_box.height
    height = 8.mm
    total_blocks = @pdf.margin_box.width / @options[:spacing]
    spacer_width = 1 * @options[:spacing]
    title_area_blocks = total_blocks / 2
    title_area_width = title_area_blocks * @options[:spacing]

    topic_area_blocks = (total_blocks / 4) - 1
    topic_area_width = topic_area_blocks * @options[:spacing]

    date_area_blocks = (total_blocks / 4) - 1
    date_area_width = date_area_blocks * @options[:spacing]

    x = 0
    # Draw title area
    @pdf.bounding_box([x, y], :width => title_area_width, :height => height) do
      @pdf.stroke_bounds
    end

    x += title_area_width + spacer_width

    # Draw topic area
    @pdf.bounding_box([x, y], :width => topic_area_width, :height => height) do
      @pdf.stroke_bounds
    end

    x += topic_area_width + spacer_width

    # Draw date area
    @pdf.bounding_box([x, y], :width => date_area_width, :height => height) do
      @pdf.stroke_bounds
    end
  end

  def draw_body
    puts "Width x Height = #{@pdf.bounds.width} x #{@pdf.bounds.height}"
    @pdf.bounding_box([0,@pdf.margin_box.height - 10.mm], :width => @pdf.margin_box.width, :height => @pdf.margin_box.height - 20.mm) do
      # @pdf.stroke_color = @options[:color]
      @pdf.stroke do
        x = @options[:spacing]
        while (x < @pdf.bounds.width - 20.mm) do
          @pdf.vertical_line 0, @pdf.bounds.height, :at => x
          x += @options[:spacing]
        end

        y = @pdf.bounds.height - @options[:spacing]
        while (y - @options[:spacing] > 0) do
          @pdf.horizontal_line 0, @pdf.bounds.width, :at => y
          y -= @options[:spacing]
        end
      end

      @pdf.stroke_color = "e3f4f8"
      @pdf.stroke_bounds
    end
  end

  def draw_footer
    @pdf.bounding_box([@pdf.margin_box.absolute_right - 33.mm, @pdf.margin_box.absolute_bottom - 10.mm], :width => 40.mm) do
      texts = [{ :text => "© 12G Solutions", :font => 'Helvetica', :size => 8, :color=>"e3f4f8" }]
      text_box = Prawn::Text::Formatted::Box.new(texts, :document => @pdf, :width => @pdf.width_of("© 12G Solutions"))
      text_box.render
    end

    center = (@pdf.margin_box.width / 2)
    nextprev_indicator_radius = 1.mm
    page_number_radius = 4.mm
    spacing = 2.mm
    top = @pdf.margin_box.absolute_bottom - 5.mm - page_number_radius
    @pdf.circle [center - spacing - page_number_radius - nextprev_indicator_radius, top], nextprev_indicator_radius
    @pdf.circle [center, top], page_number_radius
    @pdf.circle [center + spacing + page_number_radius + nextprev_indicator_radius, top], nextprev_indicator_radius

    page_id_block_width = 4 * @options[:spacing]
    @pdf.bounding_box([0,@pdf.margin_box.absolute_bottom - 5.mm], :width => page_id_block_width, :height => 8.mm) do
      @pdf.stroke_bounds
    end
  end
end
