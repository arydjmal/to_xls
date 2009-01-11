class User
  COLUMNS = %w(id name age)
  
  COLUMNS.each {|column| attr_reader column }
  
  def initialize(params={})
    COLUMNS.each {|column| eval("@#{column} = params[:#{column}]")}
  end
  
  def self.columns
    COLUMNS.collect { |column| Column.new(column) }
  end
  
  def is_old?
    age > 40
  end
end

class Column
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end