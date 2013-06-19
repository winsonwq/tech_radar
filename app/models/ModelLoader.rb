require "yaml"

class ModelLoader

  attr :fields

  def initialize file_path
    validate_path(file_path)

    raw_model = YAML::load_file file_path
    @fields = init_fields raw_model
  end

  private

  def validate_path(file_path)
    should_be_string file_path
    file_path.strip!
    should_not_be_empty file_path
    should_be_a_yml_path file_path
  end

  def init_fields raw_model
    #TODO how about fields with same name ?
    fields = []
    unless raw_model["fields"].nil?
      raw_model["fields"].to_a.each do |name, field_type|
        fields << FieldDescriptor.create({ name: name, field_type: field_type })
      end
    end
    fields
  end

  def should_not_be_empty file
    raise ArgumentError.new('file should not be empty.') if file.empty?
  end

  def should_be_string file
    raise ArgumentError.new('file should be string.') unless file.is_a? String
  end

  def should_be_a_yml_path file
    raise ArgumentError.new('file should be a yml file path.') if !file.is_a? String or (/^.+\.yml$/i =~ file).nil?
  end

end