# make sure we're running inside Merb
if defined?(Merb::Plugins)

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:dm_pagination] = {
    :chickens => false
  }
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
    require 'dm-pagination/paginatable'
    module DataMapper
      module Resource
        module ClassMethods
          include DmPagination::Paginatable
        end
      end

      class Collection
        extend DmPagination::Paginatable
      end
    end
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end
  
  Merb::Plugins.add_rakefiles "dm-pagination/merbtasks"
end
