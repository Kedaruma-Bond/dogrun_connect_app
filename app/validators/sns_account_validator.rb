class SnsAccountValidator < ActiveModel::Validator
  def validate(record)
    return if !record.facebook_id.blank? || !record.instagram_id.blank? || !record.twitter_id.blank?
    record.errors.add(:base, I18n.t('defaults.input_any_one_sns_account'))
  end
end
