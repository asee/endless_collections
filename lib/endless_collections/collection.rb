require 'active_support/core_ext/string'

module EndlessCollections
  class Column
    def initialize(name, options = {})
      @name = name
      @label = options[:label] || name.to_s.titleize
      @data = Proc.new { |row| row[name] } 
    end

    def label(new_label = "")
      if (block_given?)
        @label = yield
      else
        @label = new_label
      end
    end

    def get_label
      @label
    end

    def data(field = "", &block)
      if (block_given?)
        @data = block
      else
        @data = Proc.new { |row| row[field] } 
      end
    end

    def get_data
      @data
    end

  end

  class Collection

    # convenience method
    def columns
      @@columns
    end

    def self.columns
      @@columns
    end

    def self.define_column(name, options = {})
      @@columns ||= {}

      col = Column.new(name)
      yield col if block_given?

      @@columns[name] = col
    end

    def data_for_table
      data = []

      collection_for_report.each do |row|
        data_row = {}
        columns.each do |label, col|
          data_row[label] = col.get_data.call(row)
        end

        data << data_row
      end

      data
    end
  end
end