require "yaml"

class ModelLoader

  def initialize file
    should_be_string file
    file.strip!
    should_not_be_empty file
    should_be_a_yml_path file

  end

  private

  def should_not_be_empty file
    raise ArgumentError.new('file should not be empty.') if file.empty?
  end

  def should_be_string file
    raise ArgumentError.new('file should be string.') unless file.is_a? String
  end

  def should_be_a_yml_path file
    raise ArgumentError.new('file should be a yml file path.') if !file.is_a? String or (/^\w+\.yml$/i =~ file).nil?
  end

end