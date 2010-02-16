require File.dirname(__FILE__) + '/test_helper'

class ToXlsTest < Test::Unit::TestCase
  def setup
    @users = [
      User.new(:id => 1, :name => 'Ary', :age => 25),
      User.new(:id => 2, :name => 'Nati', :age => 22)
    ]
  end

  def test_with_empty_array
    assert_equal build_document(nil), Array.new.to_xls
  end

  def test_with_no_options
    document = build_document(
      row(cell('String', 'Age'), cell('String', 'Id'), cell('String', 'Name')),
      row(cell('Number', '25'),  cell('Number', '1'),  cell('String', 'Ary')),
      row(cell('Number', '22'),  cell('Number', '2'),  cell('String', 'Nati'))
    )
    assert_equal document, @users.to_xls
  end

  def test_with_no_headers
    document = build_document(
      row(cell('Number', '25'), cell('Number', '1'), cell('String', 'Ary')),
      row(cell('Number', '22'), cell('Number', '2'), cell('String', 'Nati'))
    )
    assert_equal document, @users.to_xls(:headers => false)
  end

  def test_with_only
    document = build_document(
      row(cell('String', 'Name')),
      row(cell('String', 'Ary')),
      row(cell('String', 'Nati'))
    )
    assert_equal document, @users.to_xls(:only => :name)
  end

  def test_with_empty_only
    assert_equal build_document(nil), @users.to_xls(:only => "")
  end

  def test_with_only_and_wrong_column_names
    document = build_document(
      row(cell('String', 'Name')),
      row(cell('String', 'Ary')),
      row(cell('String', 'Nati'))
    )
    assert_equal document, @users.to_xls(:only => [:name, :yoyo])
  end

  def test_with_except
    document = build_document(
      row(cell('String', 'Age')),
      row(cell('Number', '25')),
      row(cell('Number', '22'))
    )
    assert_equal document, @users.to_xls(:except => [:id, :name])
  end

  def test_with_except_and_only_should_listen_to_only
    document = build_document(
      row(cell('String', 'Name')),
      row(cell('String', 'Ary')),
      row(cell('String', 'Nati'))
    )
    assert_equal document, @users.to_xls(:except => [:id, :name], :only => :name)
  end

  def test_with_methods
    document = build_document(
      row(cell('String', 'Age'), cell('String', 'Id'), cell('String', 'Name'), cell('String', 'Is old?')),
      row(cell('Number', '25'),  cell('Number', '1'),  cell('String', 'Ary'),  cell('String', 'false')),
      row(cell('Number', '22'),  cell('Number', '2'),  cell('String', 'Nati'), cell('String', 'false'))
    )
    assert_equal document, @users.to_xls(:methods => [:is_old?])
  end

private
  def build_document(*rows)
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:html=\"http://www.w3.org/TR/REC-html40\" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"><Worksheet ss:Name=\"Sheet1\"><Table>#{rows}</Table></Worksheet></Workbook>"
  end

  def row(*cells)
    "<Row>#{cells}</Row>"
  end

  def cell(type, content)
    "<Cell><Data ss:Type=\"#{type}\">#{content}</Data></Cell>"
  end
end
