class User
  COLUMNS = ["id", "name", "age"]
  
  COLUMNS.each {|column| attr_reader column }
  
  def initialize(params={})
    COLUMNS.each {|column| eval("@#{column} = params[:#{column}]")}
  end
  
  def attributes
    self
  end
  
  def keys
    COLUMNS
  end
  
  def is_old?
    age > 40
  end
end
