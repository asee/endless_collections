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
          respond_to do |format|
            format.html 
            format.js do
              collection_class = opts[:with]
              row_offset = params[:start].to_i || nil
              row_limit = params[:end] ? params[:end].to_i - row_offset : nil

              Rails.logger.info("start = #{row_offset} end = #{row_limit}")

              render :json => JSON.generate({
                :resultSet => {
                  :results => collection_class.send(:data_for_table, 
                    row_offset, row_limit),
                  :firstResultPosition => row_offset,
                  :totalResultsAvailable => collection_class.send(:total_results)
                }  
              })
            end
          end
        end
      end
    end
  end
end