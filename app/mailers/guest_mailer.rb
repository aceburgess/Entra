class GuestMailer < ApplicationMailer
  default from: ENV['GMAIL_ACCOUNT']

  def buzzer_email(base_url,key,current_user,email)
    @key = key
    @url  = "#{base_url}/#{@key.secret_url}"
    mail(to: email, subject: "Access granted by #{current_user.first_name}")
  end

  def notification_email(key,current_user,message,base_url)
    @message = message
    @key = key
    @link = base_url + "/keys/#{key.id}/edit"
    @user_name = current_user.first_name
    mail(to: current_user.email, subject: "Notification from #{@key.guest.name}")
  end

  def guest_entered(key)
    @key = key
    @admin = @key.place.admin
    @guest = @key.guest
    mail(to: @admin.email, subject: "#{@guest.name} entered #{@key.place.nickname}")
  end

end
