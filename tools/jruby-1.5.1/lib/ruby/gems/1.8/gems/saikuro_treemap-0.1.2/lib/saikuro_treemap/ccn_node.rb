module SaikuroTreemap
  class CCNNode
    attr_reader :path
    
    def initialize(path, complexity=0, lines=0)
      @path = path
      @children = []
      @complexity = complexity
      @lines = lines
    end

    def add_child(child)
      @children << child
    end

    def find_node(*pathes)
      return self if pathes.join("::") == @path
      return self if pathes.empty?

      # Eumerable#find is buggy for recursive calls!
      @children.each do |child|
        if r = child.find_node(pathes)
          return r 
        end
      end
      return nil
    end

    def create_nodes(*pathes)
      pathes.each_with_index {|_, i| find_or_create_node(*pathes[0..i]) }
    end
    
    def to_json(*args)
      hash = { 'name' => compact_name, 'id' => @path, 'children' => @children }
      data = {}
      data['complexity'] =  @complexity if @complexity != 0
      data['lines'] = @lines if @lines != 0
      data['$area'] = area if area != 0
      data['$color'] = color if area != 0
      hash['data'] = data
      hash.to_json(*args)
    end
    
    def area
      return @lines if leaf?
      @children.inject(0) {|sum, child| sum + child.area }
    end
    
    def color
      return "#101010" unless leaf?
      return "#AE0000" if @complexity >= 10
      return "#006500" if @complexity < 5
      return "#4545C2"
    end
    
    def leaf?
      return @children.empty?
    end
    
    private
    
    def compact_name
      return '' if @path !~ /\S/
      @path.split('::').last.split('#').last
    end
    
    def find_or_create_node(*pathes)
      find_node(*pathes) || create_node(*pathes)
    end
    
    def create_node(*pathes)
      parent = find_node(*pathes[0..-2])
      parent.add_child(CCNNode.new(pathes.join("::")))
    end
  end
end