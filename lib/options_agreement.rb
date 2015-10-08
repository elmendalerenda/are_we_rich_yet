require 'ostruct'

class OptionsAgreement < OpenStruct
  def vested_portion(exercise_date)
    return 0.0 if exercise_date < (grant_date >> cliff_n_months)
    1.0*(cliff_pct / 100.0)
  end
end

