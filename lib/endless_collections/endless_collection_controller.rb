module EndlessCollections
  module EndlessCollectionController
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def endless_collection(action, opts = {})
        # we want to define a new action that can return
        # either the table markup or a chunk of data, 
        # depending on whether the request is for html
        # or json, and hook it up to the right
        # collection

        define_method action do
          unless (opts[:with])
            raise "A collection class or object must be provided"
          end

          # if we're passed a class, instantiate it.  otherwise, 
          # just use it directly.
          if (opts[:with].is_a?(Class)) 
            @collection = opts[:with].send(:new)
          else
            @collection = opts[:with]
          end

          respond_to do |format|
            format.html
            format.js do
              row_offset = params[:start].to_i || nil
              row_limit = params[:end] ? params[:end].to_i - row_offset : nil

              render :json => JSON.generate({
                :resultSet => {
                  :results => @collection.data_for_table(
                    row_offset, row_limit, params.except(:start, :end)),
                  :firstResultPosition => row_offset,
                  :totalResultsAvailable => @collection.total_results(params.except(:start, :end))
                }  
              })
            end
          end
        end
      end
    end
  end
end