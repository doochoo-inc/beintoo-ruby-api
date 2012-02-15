require 'rails/generators'
require 'rails/generators/active_record'

class BeintooGenerator < Rails::Generators::Base

  source_root File.expand_path("../templates", __FILE__)

  desc "This generator creates the initializer file at config/initializers"
  def copy_initializer_file
    copy_file "beintoo.rb", "config/initializers/beintoo.rb"
  end

end