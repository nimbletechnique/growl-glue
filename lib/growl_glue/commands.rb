module GrowlGlue
  module Commands
    extend Util
    
    def with_commands
      with([]) do |commands|
        yield commands
        commands.compact.each { |command| system(command) }
      end
    end
    
  end
end