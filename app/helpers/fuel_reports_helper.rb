module FuelReportsHelper
  def class_for_form_field(report, attribute)
    if report.errors[attribute].blank?
      return ''
    else
      return 'error'
    end
  end
end
