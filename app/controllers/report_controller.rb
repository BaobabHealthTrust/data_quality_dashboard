class ReportController < ApplicationController

  def dynamic_view

    @site_name = "Likuni"
    @site_errors = {
        "Male patients with breastfeeding observations" => 987,
        "Male patients with pregnant observations" => 986,
        "Missing dispensations" => 997,
        "Coding without coffee" => 20205,
        "Encounters without prescriptions" => 1187,
        "Vitals wih no weight" => 984
    }
    @site_errors = @site_errors.sort_by {|k, v| v}.reverse
    render :layout => false
  end

  def static_view

    @priority_sites = ["MPC", "Kawale", "Likuni", "Ntcheu", "Zomba", "Lighthouse", "Nkhota-kota"]
    render :layout => false
  end
end
