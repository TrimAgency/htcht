class EmailValidator < ActiveModel::EachValidator
  VALID_EMAIL_REGEX = %r{//\A[^@]+@(?:[^@]+\.)+[^@.]+\z//}

  def validate_each(record, attribute, value)
    unless value =~ VALID_EMAIL_REGEX
      record.errors.add(attribute, error_message)
    end
  end

  private

  def error_message
    options.fetch(:messages, :invalid)
  end
end
