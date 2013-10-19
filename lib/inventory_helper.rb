module InventoryHelper
  def self.included(base)
    base.class_eval do

      def inventory_object_type
        self.class.name.underscore.downcase
      end

      def catalog_object_type
        self.class.name.gsub("StoreInventory", "Catalog").underscore.downcase
      end

      def catalog_object
        send(catalog_object_type)
      end

      def image(size=:thumb)
        catalog_object.image.url(size)
      end

      def name
        catalog_object.name
      end

      def number
        catalog_object.number
      end

      def color
        catalog_object.try(:color)
      end

    end
  end
end
