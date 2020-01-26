class Admin::AuditsController < AdminController
  def index
    service = Admin::Audits::ListService.call(params)

    @audits = service.audits
    @modifier = service.modifier
  end
end
