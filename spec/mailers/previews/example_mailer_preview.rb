class ExampleMailerPreview < ActionMailer::Preview
  def new_example
    user = User.last
    raise 'No User found' if user.blank?

    ExampleMailer.new_example(user.id)
  end
end
