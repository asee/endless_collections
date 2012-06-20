#raise "hi im an error in the endless collection init"
Rails.logger.info("loading et plugin from top-level dir")

require 'endless_collections/collection'
require 'endless_collections/endless_collection_controller'

ActionController::Base.send :include, EndlessCollections::EndlessCollectionController