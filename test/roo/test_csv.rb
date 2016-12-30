require 'test_helper'

class TestRooCSV < Minitest::Test
  def test_sheets
    file = filename("numbers1")
    workbook = roo_class.new(File.join(TESTDIR, file))
    assert_equal ["default"], workbook.sheets
    assert_raises(RangeError) { workbook.default_sheet = "no_sheet" }
    assert_raises(TypeError)  { workbook.default_sheet = [1, 2, 3] }
    workbook.sheets.each do |sh|
      workbook.default_sheet = sh
      assert_equal sh, workbook.default_sheet
    end
  end

  def test_nil_rows_and_lines_csv
    # x_123
    oo = Roo::CSV.new(File.join(TESTDIR,'Bibelbund.csv'))
    oo.default_sheet = oo.sheets.first
    assert_equal 1, oo.first_row
  end

  def test_csv_parsing_with_headers
    return unless CSV
    headers = ["TITEL", "VERFASSER", "OBJEKT", "NUMMER", "SEITE", "INTERNET", "PC", "KENNUNG"]

    oo = Roo::Spreadsheet.open(File.join(TESTDIR, "Bibelbund.csv"))
    parsed = oo.parse(headers: true)
    assert_equal headers, parsed[1].keys
  end

  def roo_class
    Roo::CSV
  end

  def filename(name)
    "#{name}.csv"
  end
end
