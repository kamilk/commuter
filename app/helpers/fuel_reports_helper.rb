module FuelReportsHelper
  def class_for_form_field(report, attribute)
    if report.errors[attribute].blank?
      return ''
    else
      return 'error'
    end
  end

  def report_can_be_edited?(report)
    report.user == current_user
  end
end
