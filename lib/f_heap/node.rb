class FHeap
  class Node
    attr_accessor :parent, :value, :marked
    attr_reader :root, :children
  
    def initialize(value, root, parent = nil)
      @value    = value
      @children = []
      @marked   = false
    
      if root == :root
        @root = @parent = self
      else
        @root   = root
        @parent = parent
      end
    end
    
    def add_child!(value)
      returning(Node.new(value, root, self)) do |child|
        @children << child
      end
    end
    
    def degree
      children.count
    end
    
    def root=(new_root)
      @root   = new_root
      @parent = root if root == self
      
      unless children.empty?
        children.each do |child|
          child.root = new_root
        end
      end
    end
    
    def root?
      root == self
    end
    
    def to_s
      unless children.empty?
        "(#{value} #{children.map(&:to_s).join(', ')})"
      else
        "(#{value})"
      end
    end
  end
end