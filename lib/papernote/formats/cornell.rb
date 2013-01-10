require 'prawn'
require 'prawn/measurement_extensions'
require 'methadone'

class Cornell
  include Methadone::CLILogging

  def initialize(options={})
    @pdf = Prawn::Document.new(page_size: "A4", margin: 0)
    @pdf.line_width = 1
    (@width, @height) = @pdf.page.dimensions[2,3]
    debug("Dimensions are W: #{@width}, H: #{@height}")
    @options = { area: :graph, spacing: 8, color: "c0c0c0" }.merge(options)
  end

  def make_page
    make_cue_area
    make_title_area
    make_notes_area
    make_review_area
    make_holes
    @pdf.start_new_page
    make_title_area(:mirror)
    make_cue_area(:mirror)
    make_holes(:mirror)
    make_notes_area(:mirror)
    make_review_area(:mirror)
    @pdf
  end

  def make_holes(mirror=false)
    holes = Integer(@options[:holes]) || 0
    if holes > 0
      from_left = 11.mm
      from_left = @width - from_left if mirror
      hole_radius = 5.mm / 2
      margin = hole_radius + ((296.mm - ((holes -1) * 80.mm)) / 2)
      debug("Hole margin is #{margin}")
      debug("Hole gap is #{80.mm}")
      margin.step(296.mm, 80.mm) do |h|
        debug("Hole at #{[from_left, h]}, radius #{hole_radius}")
        @pdf.stroke_circle([from_left, h], hole_radius)
      end
    end
  end

  def make_cue_area(mirror=false)
    debug("Cue area start")
    from = 0
    to = 64.mm
    if mirror
      from = @width - from
      to = @width - to
    end
    @pdf.stroke do
      @pdf.horizontal_line from, to, at: 60.mm
      @pdf.vertical_line 60.mm, 296.mm, at: to
    end
    debug("Cue area end")
  end

  def make_title_area(mirror=false)
    x_origin = mirror ? 15.mm : 64.mm
    align = mirror ? :left : :right
    @pdf.bounding_box([x_origin, 295.mm], width: 130.mm, height: 27.mm) do
      @pdf.move_cursor_to 20.mm
      title_area_text(@options[:title], align)
      title_area_text(@options[:name], align)
      title_area_text(@options[:date], 9, align)
    end
  end

  def make_notes_area(mirror=false)
    left = 65.mm
    right = 210.mm
    if mirror
      left = @width - left
      right = @width - right
    end

    @pdf.stroke do
      @pdf.vertical_line 60.mm, 296.mm, at: left
      @pdf.horizontal_line left, right, at: 60.mm
    end
    make_grid_area(@options[:area].to_sym, mirror)
  end

  def make_grid_area(type, mirror=false)
    case type
    when :graph
      plot_graph(@options[:spacing], @options[:color], mirror)
    when :ruled
      plot_ruled(@options[:spacing], @options[:color], mirror)
    end
  end

  def plot_graph(step, color, mirror = false)
    plot_ruled(step, color, mirror)
    left = 66.mm
    right = 205.mm
    if mirror
      left = @width - left
      right = @width - right
      step = -step
    end
    old_color = @pdf.stroke_color
    @pdf.stroke do
      @pdf.stroke_color = color
      (left + step.mm).step(right, step.mm) do |pos|
        @pdf.vertical_line 265.mm, 61.mm, at: pos
      end
    end
    @pdf.stroke_color = old_color
  end

  def plot_ruled(step, color, mirror=false)
    old_color = @pdf.stroke_color
    left = 66.mm
    right = 205.mm
    if mirror
      left = @width - left
      right = @width - right
    end
    @pdf.stroke do
      @pdf.stroke_color = color
      265.mm.step((61).mm, -step.mm) do |pos|
        @pdf.horizontal_line left, right, at: pos
      end
    end
    @pdf.stroke_color = old_color
  end

  def make_review_area(mirror=false)
    @pdf.stroke do
      @pdf.horizontal_line 0, 210.mm, at: 59.mm
    end
  end

  private
  def title_area_text(txt, font_size=14, align)
    unless(txt.nil? || txt.empty?)
      @pdf.font_size=font_size
      @pdf.text(txt, :align => align)
    end
  end

end
