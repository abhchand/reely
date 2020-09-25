class ExampleMailer < BaseSendgridMailer
  def new_example(user_id)
    user = User.find(user_id)

    @recipient = user.email
    @subject = t('.subject')

    @name = user.name

    send_mail
  end
end
