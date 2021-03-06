require "yaml"

class ModelLoader

  attr :fields, :nodes, :isolate

  def initialize file_path
    validate_path(file_path)
    raw_model = YAML::load_file file_path
    @isolate = init_isolate raw_model
    @fields = init_fields raw_model
    @nodes = init_nodes raw_model
    init_relations raw_model

    @nodes.each { |key, nd| nd.create_model}
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
    fields = {}
    unless raw_model["fields"].nil?
      raw_model["fields"].to_a.each do |name, field_type|
        fields[name] = FieldDescriptor.create({ name: name, field_type: field_type })
      end
    end
    fields
  end

  def init_isolate raw_model
    raw_model["isolate"] unless raw_model["isolate"].nil?
  end

  def init_nodes raw_model
    nodes = {}
    unless raw_model["nodes"].nil?
      raw_model["nodes"].to_a.each do |name, node_config|
        node_descriptor = NodeDescriptor.create({ name: name.capitalize, isolate: isolate})
        node_config["fields"].each do |name|
          node_descriptor.field_descriptors << @fields[name] unless @fields[name].nil?
        end

        nodes[name] = node_descriptor
      end
    end
    nodes
  end

  def init_relations raw_model
    unless raw_model["nodes"].nil?
      raw_model["nodes"].to_a.each do |name, node_config|
        node_descriptor = @nodes[name.downcase]
        unless node_config["has_many"].nil?
          node_config["has_many"].each do |child_node_name|
            child_node = @nodes[child_node_name.singularize.downcase]
            node_descriptor.child_node_descriptors << child_node unless child_node.nil?
          end
        end
      end
    end

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