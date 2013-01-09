require 'prawn'
require 'prawn/measurement_extensions'

class Cornell
  def initialize(options={})
    @pdf = Prawn::Document.new(page_size: "A4", margin: 0)
    @options = options
  end

  def make_page
    make_cue_area
    make_title_area
    make_notes_area
    make_review_area
    @pdf
  end

  def make_cue_area
    @pdf.stroke do
      @pdf.line_width = 1
      @pdf.horizontal_line 0, 63.mm, at: 60.mm
      @pdf.vertical_line 60.mm, 296.mm, at: 63.mm
    end
  end

  def make_title_area
  end

  def make_notes_area
  end

  def make_review_area
    @pdf.stroke
  end

end
