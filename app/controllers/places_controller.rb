class PlacesController < ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :get_place, only: [:show, :update, :delete, :key]
  before_action :get_user, only: [:show, :create]

  def show
  end

  def new
    @place = Place.new
    respond_to do |format|
      if request.xhr?
        format.html { render :new, layout: false}
      else
        format.html { render :new }
      end
    end
  end

  def create
    new_place = Place.new(get_params)
    new_place.admin_id = @user.id
    if new_place.save
      flash[:success] = "#{new_place.nickname} was saved"
      redirect_to user_path(@user)
    else
      flash[:error] = "This place could not be saved"
      redirect_to :back #ask about changing this
    end
  end

  def update

  end

  def delete

  end

  def key
    place = Place.find_by(id: params[:id])
    if place
      keys = place.available_keys
      client_key = Key.get_available_key(keys)
    end
    if client_key
      @response = { key: client_key.id, open: true}
      @response = { key: client_key.client_id, open: true } if client_key.client_id == 0
    else
      @response = { open: false }
    end
    render :json => @response
  end

  private

  def get_params
    params.require(:place).permit(:nickname, :address)
  end

  def get_place
    @place = Place.find_by(id: params[:id])
  end

  def get_user
    @user = current_user
  end

end