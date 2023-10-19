defmodule Tutorials.Accounts.Constants do
  @required_email_message "Email is required"
  @required_email_code 100
  def validate_required_email, do: %{message: @required_email_message, code: @required_email_code}

  @invalid_email_message "Invalid Email"
  @invalid_email_code 101
  def validate_invalid_email, do: %{message: @invalid_email_message, code: @invalid_email_code}

  @max_length_email_message "The maximum length of an email is 160 characters"
  @max_length_email_code 102
  def validate_max_length_email, do: %{message: @max_length_email_message, code: @max_length_email_code}

  @exists_email_message "Email already exists"
  @exists_email_code 103
  def validate_exists_email, do: %{message: @exists_email_message, code: @exists_email_code}

  @required_hash_password_message "Hash password is required"
  @required_hash_password_code 110
  def validate_required_hash_password, do: %{message: @required_hash_password_message, code: @required_hash_password_code}
end
