#-------------------------------------------------------------------------------
#
# Thomas Thomassen
# thomas[at]thomthom[dot]net
#
#-------------------------------------------------------------------------------

require 'sketchup.rb'


#-------------------------------------------------------------------------------

module TT::Plugins::SmoothHidden

  ### MENU & TOOLBARS ### ------------------------------------------------------

  unless file_loaded?( File.basename(__FILE__) )
    plugin_menu = UI.menu('Plugin')
    plugin_menu.add_item('Smooth Hidden Edges')   { self.smooth_hidden }
  end


  ### MAIN SCRIPT ### ----------------------------------------------------------

  def self.smooth_hidden
    model = Sketchup.active_model

    self.start_operation("Smooth Hidden")

    for e in model.entities
      self.smooth_hidden_edge(e)
    end
    for d in model.definitions
      next if d.image?
      for e in d.entities
        self.smooth_hidden_edge(e)
      end
    end

    model.commit_operation
  end

  def self.smooth_hidden_edge(e)
    if e.is_a?(Sketchup::Edge) && e.hidden?
      e.hidden = false
      e.smooth = true
      e.soft = true
    end
  end


  ### HELPER METHODS ### ------------------------------------------------------

  def self.start_operation(name)
    model = Sketchup.active_model
    if Sketchup.version.split('.')[0].to_i >= 7
      model.start_operation(name, true)
    else
      model.start_operation(name)
    end
  end

end # module

#-------------------------------------------------------------------------------

file_loaded( __FILE__ )

#-------------------------------------------------------------------------------