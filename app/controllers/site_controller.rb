class SiteController < ApplicationController

  def add_site
    render :layout => false
  end

  def edit_site
    @sites = Site.all
    render :layout => false
  end

  def map
    @region = params["region"] rescue nil
    @label = nil

    @region = "blank" if @region.blank?

    case @region.to_s.downcase
      when "centre"
        @label = "Central Region"
      when "north"
        @label = "Northern Region"
      when "south"
        @label = "Southern Region"
    end

    @x = nil
    @y = nil

    if !params["x"].blank?
      @x = params["x"]
    end

    if !params["y"].blank?
      @y = params["y"]
    end

    render :layout => false
  end

  def save_site
    return Site.add_site(params[:site], params[:code],params[:host],params[:port],params[:region],params[:x],params[:y])
  end

  def update_current_site

    Site.current = Site.find_by_name(params[:site])
    render :layout => false
  end

  def get_current_site

    site_name = Site.current
    render :text => (Site.current.name rescue "").to_json

  end
end
