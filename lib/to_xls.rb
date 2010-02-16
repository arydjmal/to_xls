class Array
  def to_xls(options = {})
    output = '<?xml version="1.0" encoding="UTF-8"?><Workbook xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office"><Worksheet ss:Name="Sheet1"><Table>'

    if self.any?
      klass      = self.first.class
      attributes = self.first.attributes.keys.sort.map(&:to_sym)

      if options[:only]
        columns = Array(options[:only]) & attributes
      else
        columns = attributes - Array(options[:except])
      end

      columns += Array(options[:methods])

      if columns.any?
        unless options[:headers] == false
          output << "<Row>"
          columns.each { |column| output << "<Cell><Data ss:Type=\"String\">#{klass.human_attribute_name(column)}</Data></Cell>" }
          output << "</Row>"
        end    

        self.each do |item|
          output << "<Row>"
          columns.each do |column|
            value = item.send(column)
            output << "<Cell><Data ss:Type=\"#{value.is_a?(Integer) ? 'Number' : 'String'}\">#{value}</Data></Cell>"
          end
          output << "</Row>"
        end
      end
    end

    output << '</Table></Worksheet></Workbook>'
  end
end
