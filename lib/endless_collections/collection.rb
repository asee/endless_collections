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

    def initialize(opts = {})
      unless (opts[:find_default_cols])
        # attempt to define default columns using the data 
        first_row = self.fetch_collection_data(0, 1).first
        if (first_row)
          # if the row responds to attributes, use them
          attrs = first_row.try(:attributes)

          if (attrs) 
            attrs.keys.each do |attr|
              define_column attr
            end
          # TODO support hashes
          end
        end
      end
    end

    # these functions must be defined by the user
    def fetch_collection_data(offset=nil, limit=nil, opts = {})
      raise "The fetch_collection_data method must be defined by your report class"
    end

    def total_results(opts = {})
      raise "The total_results method must be defined by your report class"
    end

    def columns
      @columns.values
    end

    # this should be overridden if the user wants to select their columns
    def columns_for_display
      columns
    end

    def define_column(name, options = {}, &block)
      @columns ||= {}

      col = Column.new(name, options)
      yield col if block_given?

      @columns[name] = col
    end

    def data_for_table(offset = nil, limit = nil, opts = {})
      data = []

      fetch_collection_data(offset, limit, opts).each do |row|
        data_row = {}
        columns_for_display.each do |col|
          data_row[col.name] = col.data.call(row)
        end

        data << data_row
      end

      data
    end

    def table_column_defs
      columns_for_display.collect do |c|
        {
          "label" => c.label,
          "sortable" => false,
          "resizeable" => true,
          "key" => c.name
        }
      end
    end

    def response_schema
      columns_for_display.collect do |c|
        { "key" => c.name }
      end
    end
  end
end