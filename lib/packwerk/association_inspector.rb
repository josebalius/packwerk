# typed: true
# frozen_string_literal: true

require "packwerk/constant_name_inspector_interface"
require "packwerk/node"

module Packwerk
  # Extracts the implicit constant reference from an active record association
  class AssociationInspector
    include ConstantNameInspectorInterface

    RAILS_ASSOCIATIONS = %i(
      belongs_to
      has_many
      has_one
      has_and_belongs_to_many
    ).to_set

    def initialize(inflector: Inflector.new, custom_associations: Set.new)
      @inflector = inflector
      @associations = RAILS_ASSOCIATIONS + custom_associations
    end

    def constant_name_from_node(node, ancestors:)
      return unless Node.type(node) == Node::METHOD_CALL

      method_name = Node.method_name(node)
      return nil unless @associations.include?(method_name)

      arguments = Node.method_arguments(node)
      association_name = Node.literal_value(arguments[0]) if Node.type(arguments[0]) == Node::SYMBOL
      return nil unless association_name

      association_options = arguments.detect { |n| Node.type(n) == Node::HASH }
      class_name_node = Node.value_from_hash(association_options, :class_name) if association_options

      if class_name_node
        Node.literal_value(class_name_node) if Node.type(class_name_node) == Node::STRING
      else
        @inflector.classify(association_name.to_s)
      end
    end
  end
end
