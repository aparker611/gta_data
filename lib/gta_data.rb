require 'nokogiri'
require 'json'
#####Fields#####
###first_name###
###last_name ###
###   money  ###
###   level  ###
###  stamina ###
### shooting ###
### strength ###
### stealth  ###
###  flying  ###
### driving  ###
### lung_cap ###
###  mental  ###
################
class GtaData
  def run(file)
    return puts 'Please provide a valid filename' if file.nil? || !File.exist?(file)
    file_path = file
    content = Nokogiri::XML(File.read(file_path))
    validate_input_xml(content)
  end

  def convert_to_json(xml)
    xml = xml
    id            = set_stat_values(xml, "ID")
    first_name    = set_stat_values(xml, "FirstName")
    last_name     = set_stat_values(xml, "LastName")
    money         = set_stat_values(xml, "Money")
    level         = set_stat_values(xml, "Level")
    stamina       = set_stat_values(xml, "Stamina")
    shooting      = set_stat_values(xml, "Shooting")
    strength      = set_stat_values(xml, "Strength")
    stealth       = set_stat_values(xml, "Stealth")
    flying        = set_stat_values(xml, "Flying")
    driving       = set_stat_values(xml, "Driving")
    lung_capacity = set_stat_values(xml, "LungCapacity")
    mental_state  = set_stat_values(xml, "MentalState")

  end


  def set_stat_values(xml, stat)
    return "There has been an error with setting the stat values" if !stat || !xml
    return xml.css("#{stat}").map { |node| node.children.text }
  end

  def validate_input_xml(xml)
    xml, schema = xml, Nokogiri::XML::Schema(File.read("./schemas/gta_data_schema.xsd"))
    return "There has been an error while validating the xml file" if !xml || !schema
    schema.validate(xml).each do |error|
      puts error.message
    end
    convert_to_json(xml)
  end

  def convert_money(money)
    formatted_money = money.reverse.gsub(/...(?=.)/,'\&,').reverse
    return formatted_money if formatted_money
  end
end
