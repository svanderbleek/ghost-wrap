require 'tempfile'

# must call clean if you use, see spec
class GhostWrap
  TEMPDIR = Pathname.new('.')
  attr_reader :file

  def initialize(pdf_data)
    @tempfiles = []
    @file = create_tempfile(pdf_data)
  end

  def join(other_ghost_wrap)
    @file = join_file(other_ghost_wrap.file)
    self
  end

  def data
    File.read(@file)
  end

  def page_files
    @page_files ||= split_page_images
  end

  def clean
    @tempfiles.each do |tempfile|
      File.delete(tempfile)
    end
    @tempfiles = []
  end

  private

  def join_file(file)
    join_data = `gs -dSAFER -r128 -o -q -sDEVICE=pdfwrite -sOutputFile=%stdout% #{@file.path} #{file.path}`
    reset_page_files
    create_tempfile(join_data)
  end

  def reset_page_files
    @page_files = nil
  end

  def split_page_images
    `gs -dSAFER -r128 -o -q -sDEVICE=png256 -sOutputFile=#{@file.path}-page%04d #{@file.path}`

    page_files = Dir[TEMPDIR.join("#{@file.path}-page*")].sort.map do |page_file|
      File.open(page_file)
    end

    @tempfiles += page_files

    page_files
  end

  def create_tempfile(data)
    @tempfiles << Tempfile.open('pdf', TEMPDIR, encoding: 'ascii-8bit') do |tempfile|
      tempfile.write(data)
      tempfile
    end
    @tempfiles.last
  end
end
