require 'active_support/core_ext/string'

module EndlessCollections
  class Column
    def initialize(name, options = {})
      @name = name
      @label = options[:label] || @name.to_s.titleize
      @data = Proc.new { |row| row[name] } 
    end

    def name
      @name
    end

    def label(new_label = nil)
      if (block_given?)
        @label = yield
      elsif (!new_label.nil?)
        @label = new_label
      end
      @label
    end

    def data(field = nil, &block)
      if (block_given?)
        @data = block
      elsif (!field.nil?)
        @data = Proc.new { |row| row[field] } 
      end
      @data
    end

  end

  class Collection
    class << self
      def columns
        @@columns
      end

      def define_column(name, options = {}, &block)
        @@columns ||= {}

        col = Column.new(name, options)
        yield col if block_given?

        @@columns[name] = col
      end

      def data_for_table(offset = nil, limit = nil)
        data = []

        fetch_collection_data(offset, limit).each do |row|
          data_row = {}
          columns.each do |label, col|
            data_row[label] = col.data.call(row)
          end

          data << data_row
        end

        data
      end

      # TODO make these attributes read from the definitions
      def table_column_defs
        columns.values.collect do |c|
          {
            "label" => c.label,
            "sortable" => false,
            "key" => c.name
          }
        end
      end

      def response_schema
        columns.values.collect do |c|
          { "key" => c.name }
        end
      end

      # TODO implement this
      def filter_variables
        []
      end
    end
  end
end