require "rubygems"
require "active_support/inflector"
require "f_heap"

class FHeap
  Dir.glob(File.join(File.dirname(__FILE__), "lib", "f_heap", "*.rb")).each do |path|
    autoload(:"#{ActiveSupport::Inflector.classify(File.basename(path, ".rb"))}", path)
  end
end

class Object
  def returning(object)
    yield object
    object
  end
end