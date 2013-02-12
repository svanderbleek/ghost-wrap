require 'spec_helper'

describe GhostWrap do
  let!(:pdf_data) { joined_pdf_data = File.read(Rails.root.join('spec/fixtures/Test001.pdf')) }
  let!(:joined_pdf_data) { File.read(Rails.root.join('spec/fixtures/JoinTest.pdf')) }

  let(:ghost_wrap) { GhostWrap.new(pdf_data) }
  let(:another_ghost_wrap) { GhostWrap.new(pdf_data) }
  let(:two_page_ghost_wrap) { GhostWrap.new(joined_pdf_data) }

  after(:each) do
    ghost_wrap.clean
    another_ghost_wrap.clean
    two_page_ghost_wrap.clean
  end

  it "acts as a file wrapper around pdf data" do
    File.read(ghost_wrap.file).should eq(pdf_data)
    ghost_wrap.data.should eq(pdf_data)
  end

  it "joins data with another GhostWrap" do
    joined_data = ghost_wrap.join(another_ghost_wrap).data

    joined_data.size.should be_within(500).of(joined_pdf_data.size)
  end

  it "creates page files" do
    page_files = two_page_ghost_wrap.page_files

    page_files.size.should eq(2)
  end

  it "cleans temporary files" do
    files = []
    files << ghost_wrap.file
    files += ghost_wrap.page_files
    files << ghost_wrap.join(another_ghost_wrap).file
    files += ghost_wrap.page_files

    ghost_wrap.clean

    files.map do |file|
      File.exists?(File.expand_path(file))
    end.should_not include(true)
  end
end
