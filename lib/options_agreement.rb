require 'ostruct'

class OptionsAgreement < OpenStruct
  def vested_portion(exercise_date)
    return 0.0 if exercise_date < (grant_date >> cliff_n_months)

    cliff_release_portion = (cliff_pct / 100.0)

    pct_per_month = (1.0 - cliff_release_portion) / vesting_period
    cliff_ends = grant_date >> cliff_n_months

    vested_months = exercise_date.month - cliff_ends.month + 12 * (exercise_date.year - cliff_ends.year)
    pct = cliff_release_portion + (vested_months * pct_per_month)
    pct
  end
end

