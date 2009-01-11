require 'test/unit'
require 'rubygems'
require File.dirname(__FILE__) + '/../lib/to_xls'
require File.dirname(__FILE__) + '/user_model'

class ToXlsTest < Test::Unit::TestCase

  def setup
    @users = []
    @users << User.new(:id => 1, :name => 'Ary', :age => 24)
    @users << User.new(:id => 2, :name => 'Nati', :age => 21)
  end

  def test_with_empty_array
    assert_equal( "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:html=\"http://www.w3.org/TR/REC-html40\" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"><Worksheet ss:Name=\"Sheet1\"><Table></Table></Worksheet></Workbook>", [].to_xls )
  end
  
  def test_with_no_options
    assert_equal( "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:html=\"http://www.w3.org/TR/REC-html40\" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"><Worksheet ss:Name=\"Sheet1\"><Table><Row><Cell><Data ss:Type=\"String\">id</Data></Cell><Cell><Data ss:Type=\"String\">name</Data></Cell><Cell><Data ss:Type=\"String\">age</Data></Cell></Row><Row><Cell><Data ss:Type=\"Number\">1</Data></Cell><Cell><Data ss:Type=\"String\">Ary</Data></Cell><Cell><Data ss:Type=\"Number\">24</Data></Cell></Row><Row><Cell><Data ss:Type=\"Number\">2</Data></Cell><Cell><Data ss:Type=\"String\">Nati</Data></Cell><Cell><Data ss:Type=\"Number\">21</Data></Cell></Row></Table></Worksheet></Workbook>", @users.to_xls )
  end
  
  def test_with_no_headers
    assert_equal( "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:html=\"http://www.w3.org/TR/REC-html40\" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"><Worksheet ss:Name=\"Sheet1\"><Table><Row><Cell><Data ss:Type=\"Number\">1</Data></Cell><Cell><Data ss:Type=\"String\">Ary</Data></Cell><Cell><Data ss:Type=\"Number\">24</Data></Cell></Row><Row><Cell><Data ss:Type=\"Number\">2</Data></Cell><Cell><Data ss:Type=\"String\">Nati</Data></Cell><Cell><Data ss:Type=\"Number\">21</Data></Cell></Row></Table></Worksheet></Workbook>", @users.to_xls(:headers => false) )
  end
  
  def test_with_only
    assert_equal( "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:html=\"http://www.w3.org/TR/REC-html40\" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"><Worksheet ss:Name=\"Sheet1\"><Table><Row><Cell><Data ss:Type=\"String\">name</Data></Cell></Row><Row><Cell><Data ss:Type=\"String\">Ary</Data></Cell></Row><Row><Cell><Data ss:Type=\"String\">Nati</Data></Cell></Row></Table></Worksheet></Workbook>", @users.to_xls(:only => :name) )
  end
  
  def test_with_empty_only
    assert_equal( "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:html=\"http://www.w3.org/TR/REC-html40\" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"><Worksheet ss:Name=\"Sheet1\"><Table></Table></Worksheet></Workbook>", @users.to_xls(:only => "") )
  end
  
  def test_with_only_and_wrong_column_names
    assert_equal( "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:html=\"http://www.w3.org/TR/REC-html40\" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"><Worksheet ss:Name=\"Sheet1\"><Table><Row><Cell><Data ss:Type=\"String\">name</Data></Cell></Row><Row><Cell><Data ss:Type=\"String\">Ary</Data></Cell></Row><Row><Cell><Data ss:Type=\"String\">Nati</Data></Cell></Row></Table></Worksheet></Workbook>", @users.to_xls(:only => [:name, :yoyo]) )
  end
  
  def test_with_except
    assert_equal( "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:html=\"http://www.w3.org/TR/REC-html40\" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"><Worksheet ss:Name=\"Sheet1\"><Table><Row><Cell><Data ss:Type=\"String\">age</Data></Cell></Row><Row><Cell><Data ss:Type=\"Number\">24</Data></Cell></Row><Row><Cell><Data ss:Type=\"Number\">21</Data></Cell></Row></Table></Worksheet></Workbook>", @users.to_xls(:except => [:id, :name]) )
  end
  
  def test_with_except_and_only_should_listen_to_only
    assert_equal( "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:html=\"http://www.w3.org/TR/REC-html40\" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"><Worksheet ss:Name=\"Sheet1\"><Table><Row><Cell><Data ss:Type=\"String\">name</Data></Cell></Row><Row><Cell><Data ss:Type=\"String\">Ary</Data></Cell></Row><Row><Cell><Data ss:Type=\"String\">Nati</Data></Cell></Row></Table></Worksheet></Workbook>", @users.to_xls(:except => [:id, :name], :only => :name) )
  end
  
  def test_with_except
    assert_equal( "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Workbook xmlns:x=\"urn:schemas-microsoft-com:office:excel\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:html=\"http://www.w3.org/TR/REC-html40\" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"><Worksheet ss:Name=\"Sheet1\"><Table><Row><Cell><Data ss:Type=\"String\">id</Data></Cell><Cell><Data ss:Type=\"String\">name</Data></Cell><Cell><Data ss:Type=\"String\">age</Data></Cell><Cell><Data ss:Type=\"String\">is_old?</Data></Cell></Row><Row><Cell><Data ss:Type=\"Number\">1</Data></Cell><Cell><Data ss:Type=\"String\">Ary</Data></Cell><Cell><Data ss:Type=\"Number\">24</Data></Cell><Cell><Data ss:Type=\"String\">false</Data></Cell></Row><Row><Cell><Data ss:Type=\"Number\">2</Data></Cell><Cell><Data ss:Type=\"String\">Nati</Data></Cell><Cell><Data ss:Type=\"Number\">21</Data></Cell><Cell><Data ss:Type=\"String\">false</Data></Cell></Row></Table></Worksheet></Workbook>", @users.to_xls(:methods => [:is_old?]) )
  end
  
end
