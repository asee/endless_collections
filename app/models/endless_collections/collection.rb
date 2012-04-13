require 'active_support'

module EndlessCollections
  class Column
    def initialize(name, options = {})
      @name = name
      @label = options[:label] || name
    end

    def label(new_label = "")
      if (block_given?)
        @label = yield
      else
        @label = new_label
      end
    end
  end

  class Collection

    def columns
      @columns
    end

    def define_column(name, options = {})
      @columns ||= {}

      col = Column.new(name)

      yield col if block_given?

      @columns[name] = col
    end
  end
end