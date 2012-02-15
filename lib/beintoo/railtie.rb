module Beintoo
  class Railtie < Rails::Railtie
    initializer 'beintoo.model_additions' do
      ActiveSupport.on_load :active_record do
        extend ModelAdditions
      end
    end
  end
end