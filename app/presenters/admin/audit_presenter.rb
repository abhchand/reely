class Admin::AuditPresenter < ApplicationPresenter
  def modifier
    audit.user
  end

  def description
    @description ||= fetch_description
  end

  def created_at
    audit.created_at.strftime(I18n.t("time.formats.month_day_and_year"))
  end

  def created_at_alt_text
    audit.created_at.strftime(I18n.t("time.formats.timestamp_with_zone"))
  end

  private

  def fetch_description
    {
      error: false,
      text: description_service_class.call(audit).html_safe
    }
  rescue Admin::Audit::BaseDescriptionService::DescriptionError => e
    {
      error: true,
      text: e.message
    }
  end

  def audit
    model
  end

  def description_service_class
    "Admin::Audit::#{audit.auditable_type}DescriptionService".constantize
  end
end
