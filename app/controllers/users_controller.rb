class UsersController < ApplicationController
  def index
    if current_user
      flash.keep(:notice)
      flash.keep(:error)
      redirect_to user_path(current_user)
    else
      redirect_to signup_path, notice: "Fucks sake"
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = params[:user] ? User.new(params[:user]) : guest_signup
    respond_to do |format|
      if @user.save
        if params[:remember_me]
        cookies.permanent[:auth_token] = @user.auth_token
      else
        cookies[:auth_token] = @user.auth_token
      end
        flash[:notice] = 'Thank you for signing up!.'
        format.html { redirect_to(@user) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def stripe_disconnect
    current_user.api_key = nil
    current_user.save!
    redirect_to root_path, notice: "Stipe API key reset"
  end
end

private

  def guest_signup
    user = User.create(email: "", name: "Guest", password: "guestuser", password_confirmation: "guestuser")
    about_text = placeholder = "#Read this first!\n\n---\n\n###You can edit this page by clicking on any element that is marked with an  icon. All your changes should be saved automatically.\n\n####This page uses redcarpet markdown for formating, you can also embed media objects and images.\n\n####Don't forget to mention the lineup for the night:\n1. [Crete Boom](http://creteboom.com/).\n2. [Another Band](http://example.com/).\n\n> fuckin A\n\n####Here's some Crete Boom vids, first youtube:\n\nhttp://www.youtube.com/watch?v=AQ_6sGiglm4\n\nthen vimeo (try resizing the browser all embeds should be responsive)\n\nhttp://vimeo.com/57855999\n\n####Here's a map for the venue\n\nhttps://maps.google.com/maps?q=irish+times&hl=en&ll=37.79483,-122.395914&spn=0.011411,0.019913&sll=37.793694,-122.395828&sspn=0.011412,0.019913&t=h&radius=0.65&hq=irish+times&z=16"
    cookies[:auth_token] = user.auth_token
    event = user.events.create(name: "Example Show", date: 3.months.from_now, ticket_price: 10, location: "Dublin, Ireland", about: about_text)
    redirect_to event_path(@event.id), notice: "Welcome to your event, you can save this account at any time,
     click on 'save your account' in the top menu"
  end
