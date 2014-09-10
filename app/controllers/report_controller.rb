class ReportController < ApplicationController

  def dynamic_view

    render :layout => false
  end

  def static_view

    render :layout => false
  end
end
