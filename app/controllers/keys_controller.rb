class KeysController < ApplicationController
  before_action :get_key, only: [:update, :used_at, :destroy,:edit]
  before_action :require_login, only: [:show, :new, :edit, :destroy]

  def show

  end

  # def new
  #   @key = Key.new
  #   respond_to do |format|
  #     if request.xhr?
  #       format.html { render :new, layout: false}
  #     else
  #       format.html { render :new }
  #     end
  #   end
  # end

  def create
    @key = Key.new
    @key.place_id = params[:place_id]
    @key.start_date = Time.now.getutc
    @key.end_date = @key.start_date + 24.hours
    @guest = Guest.where(email: 'entra.app+anonymous@gmail.com', user_id:current_user.id, phone:'none', name:'Anonymous Guest').first_or_create
    @key.guest = @guest
    if @key.save
      respond_to do |format|
        if request.xhr?
          format.html { render :new, layout: false}
        else
          format.html { render :new }
        end
      end
    end
    # new_key = Key.new(get_params)
    # if new_key.save
    #   send_mail new_key
    #   flash[:success] = "New key created"
    #   redirect_to place_path(new_key.place)
    # else
    #   flash[:error] = "Key could not be created :("
    #   redirect_to user_path(current_user)
    # end
  end

  def edit

  end

  def update
    @key.assign_attributes(get_params)
    @key.update_key_access params
    saved = @key.save
    return flash[:error] = 'Key was not saved' unless saved
    if request.xhr?
      if params[:partial]
        render partial:'key',locals:{key:@key},layout: false
      else
        render json: {updated: saved}
      end
    else
      flash[:success] = "Key reactivated" if saved
      redirect_to place_path(@key.place)
    end
  end

  def im_done
    flash[:success] = "New key created!"
    redirect_to root_path
  end

  def used_at
    activity = @key.logs.build()
    @key.used_at = Time.now if (params[:status] == 'opened')
    @key.requested = false if @key.unlimited_access
    if (params[:status] == 'closed')
      GuestMailer.guest_entered(@key)
      activity.guest_access(@key)
    else
      activity.destroy
    end
    @key.save
    render :json => params
  end

  def destroy
    if @key.destroy
      if request.xhr?
        flash[:alert] = "Key has been deleted"
        render json: {deleted: true}
      else
        redirect_to root_path
      end
    else
      flash[:error] = "Key was not deleted"
    end
  end

  def find_guests_key_by_url
    @key = Key.find_by(secret_url: params[:hash])
    @place = @key.place
  end

  def send_email
    key = Key.find_by(secret_url: params[:sc_url])
    GuestMailer.buzzer_email(base_url,key,current_user,params[:email]).deliver_now
    render json: {email:'sent'}
  end

  private

  def get_params
    params.require(:key).permit(
      :place_id,
      :start_date,
      :guest_id,
      :end_date,
      :requested,
      :used_at,
      :unlimited_access
      )
  end

  def send_mail key
    GuestMailer.buzzer_email(base_url, key, current_user).deliver_now
  end

  def get_key
    @key = Key.find_by(id: params[:id])
  end

end