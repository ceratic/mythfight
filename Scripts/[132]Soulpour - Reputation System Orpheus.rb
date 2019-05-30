#==============================================================================
# ** Soulpour - Reputation System Orpheus
# Author: Soulpour777
# Web URL: infinitytears.wordpress.com
# Credits: Animeflow for the Wallpaper
#------------------------------------------------------------------------------
# Description:
# This script allows you to create a reputation system with a graphical user 
# interface.
#------------------------------------------------------------------------------
# Installation:
#------------------------------------------------------------------------------
# Put the script below Materials above Main.
# Make sure that the needed graphics are installed under Systems folder.
# For more information, you can download or use the demo.
#------------------------------------------------------------------------------
# Usage:
# Combining with eventing, you can add or subtract your reputation.
#------------------------------------------------------------------------------
# Script Call:
# To call this script, use this script call:
# SceneManager.call(Soul_Orpheus_Reputation)
#==============================================================================
module Soulpour
  module Reputation
    REPUTATION_VARIABLE = 1              #=> Variable that holds the Reputation
    REPUTATION_MAX = 100      #=> Maximum Amount of Reputation (min.f / max)
    REPUTATION_GOOD = "good_notif"        #=> Good Reputation Graphic
    REPUTATION_NEUTRAL = "neutral_notif"  #=> Neutral Reputation Graphic
    REPUTATION_BAD = "bad_notif"         #=> Bad Reputation Graphic
    REPUTATION_WALLPAPER = "reputation_wallpaper" #=> Reputation Wallpaper
    REPUTATION_BANNER = "reputation_banner" #=> Reputation Banner Graphic
    REPUTATION_PARTICLE = "reputation_particle" #=> Reputation Particle Graphic
    GAUGE_HEIGHT = 24 #=> Height Value of the Gauge
    WINDOW_OPACITY = 0 #=> Window Opacity
    GRAPHICS_HEIGHT = 250
    
    #--------------------------------------------------------------------------
    # * Change Width
    #--------------------------------------------------------------------------     
    def self.graphics_width_form
      return Graphics.width
    end
    #--------------------------------------------------------------------------
    # * Change Height
    #--------------------------------------------------------------------------     
    def self.graphics_height_form
      return Soulpour::Reputation::GRAPHICS_HEIGHT
    end
  end

  
end

#==============================================================================
# ** Window_Reputation
#------------------------------------------------------------------------------
#  This class performs window reputation processing.
#==============================================================================
class Window_Reputation < Window_Base
  #--------------------------------------------------------------------------
  # * Reputation Gauge Color
  #--------------------------------------------------------------------------  
  def reputation_gauge_1;   text_color(16);  end; 
  def reputation_gauge_2;   text_color(9);  end; 
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, window_height)
    refresh
    self.opacity = Soulpour::Reputation::WINDOW_OPACITY
    self.z = 100
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    Soulpour::Reputation.graphics_width_form
  end
  
  #--------------------------------------------------------------------------
  # * Window Height
  #--------------------------------------------------------------------------  
  def window_height
    Soulpour::Reputation.graphics_height_form
  end
  
  #--------------------------------------------------------------------------
  # * Draw Reputation Gauge
  #     rate   : Rate (full at 1.0)
  #     color1 : Left side gradation
  #     color2 : Right side gradation
  #--------------------------------------------------------------------------
  def draw_reputation_gauge(x, y, width, rate, color1, color2)
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8
    contents.fill_rect(x, gauge_y, width, Soulpour::Reputation::GAUGE_HEIGHT, gauge_back_color)
    contents.gradient_fill_rect(x, gauge_y, fill_w, Soulpour::Reputation::GAUGE_HEIGHT, color1, color2)
  end  
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_text_ex(x, 40, "Reputation Rate: " + $game_variables[Soulpour::Reputation::REPUTATION_VARIABLE].to_s + " / " + Soulpour::Reputation::REPUTATION_MAX.to_s)
    draw_reputation_gauge(0, 50, 300, $game_variables[Soulpour::Reputation::REPUTATION_VARIABLE].to_f / Soulpour::Reputation::REPUTATION_MAX, reputation_gauge_1, reputation_gauge_2)
  end
  
  #--------------------------------------------------------------------------
  # * Open Window
  #--------------------------------------------------------------------------
  def open
    refresh
    super
  end
  
end

#==============================================================================
# ** Soul_Orpheus_Reputation
#------------------------------------------------------------------------------
#  This class performs the Orpheus Reputation Scene processing.
#==============================================================================
class Soul_Orpheus_Reputation < Scene_Base
  
  def start
    super
    start_reputation_system_window
    create_reputation_wallpaper(Soulpour::Reputation::REPUTATION_WALLPAPER)
    create_reputation_particle(Soulpour::Reputation::REPUTATION_PARTICLE)
    create_reputation_banner_spr(Soulpour::Reputation::REPUTATION_BANNER)
    if $game_variables[Soulpour::Reputation::REPUTATION_VARIABLE] == 50
      create_notification_banner(Soulpour::Reputation::REPUTATION_NEUTRAL)
    elsif $game_variables[Soulpour::Reputation::REPUTATION_VARIABLE] > 50
      create_notification_banner(Soulpour::Reputation::REPUTATION_GOOD)
    else
      create_notification_banner(Soulpour::Reputation::REPUTATION_BAD)
    end    
    if $game_variables[Soulpour::Reputation::REPUTATION_VARIABLE] < 0
      $game_variables[Soulpour::Reputation::REPUTATION_VARIABLE] = 0
    end    
  end

  #--------------------------------------------------------------------------
  # * start_reputation_system_window : new method
  #--------------------------------------------------------------------------  
  def start_reputation_system_window
    @reputation_system_window = Window_Reputation.new
  end  
  
  #--------------------------------------------------------------------------
  # * create_reputation_wallpaper : new method
  #--------------------------------------------------------------------------    
  def create_reputation_wallpaper(wallpaper_name)
    @reputation_wallpaper = Sprite.new
    @reputation_wallpaper.bitmap = Cache.system(wallpaper_name)
  end  
  
  #--------------------------------------------------------------------------
  # * update_reputation_particle : new method
  #--------------------------------------------------------------------------  
  def update_reputation_particle
    @reputation_particle.oy -= -1
  end
  
  #--------------------------------------------------------------------------
  # * dispose_reputation_particle : new method
  #--------------------------------------------------------------------------    
  def dispose_reputation_particle
    @reputation_particle.bitmap.dispose
    @reputation_particle.dispose
  end    
  
  #--------------------------------------------------------------------------
  # * dispose_reputation_wallpaper : new method
  #--------------------------------------------------------------------------  
  def dispose_reputation_wallpaper
    @reputation_wallpaper.bitmap.dispose
    @reputation_wallpaper.dispose
  end    
  
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------  
  def update
    update_basic
    if Input.press?(:B)
      Sound.play_cancel
      return_scene
    end
    update_reputation_particle    
  end  
  
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    Graphics.freeze
    dispose_all_windows
    dispose_main_viewport 
    dispose_reputation_wallpaper
    dispose_reputation_particle    
    dispose_notification_banner
    dispose_reputation_banner_spr    
  end  
  
  #--------------------------------------------------------------------------
  # * create_reputation_banner_spr : new method
  #--------------------------------------------------------------------------  
  def create_reputation_banner_spr(sprite_name)
    @reputation_banner_spr = Sprite.new
    @reputation_banner_spr.bitmap = Cache.system(sprite_name)
    @reputation_banner_spr.x = 30
    @reputation_banner_spr.y = 0
    @reputation_banner_spr.z = 110
  end

  #--------------------------------------------------------------------------
  # * dispose_reputation_banner_spr : new method
  #--------------------------------------------------------------------------   
  def dispose_reputation_banner_spr
    @reputation_banner_spr.bitmap.dispose
    @reputation_banner_spr.dispose
  end
  
  #--------------------------------------------------------------------------
  # * create_reputation_particle : new method
  #--------------------------------------------------------------------------   
  def create_reputation_particle(particle_name)
    @reputation_particle = Plane.new
    @reputation_particle.bitmap = Cache.system(particle_name)
    @reputation_particle.z = 110
  end
  
  #--------------------------------------------------------------------------
  # * create_notification_banner : new method
  #--------------------------------------------------------------------------   
  def create_notification_banner(var)
    @notif_banner = Plane.new
    @notif_banner.bitmap = Cache.system(var)
    @notif_banner.z = 110
  end

  #--------------------------------------------------------------------------
  # * dispose_notification_banner : new method
  #--------------------------------------------------------------------------   
  def dispose_notification_banner
    @notif_banner.bitmap.dispose
    @notif_banner.dispose
  end
  
end

$soulpour_reputation_rgss3 = true
