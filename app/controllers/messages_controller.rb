class MessagesController < ApplicationController
before_filter :find_message, :only => [ :show, :edit, :update, :destroy]  
before_filter :check_session, :only => [:create] 
  def index
    @messages = Message.page(params[:page]).per(5)
  end
  
  def show
  end
  
  def edit
  end
  
  def destroy
    flash[:note] = "message was successfully deleted"
    @message.destroy
    redirect_to :action => :index
  end
  
  def create #new->_form->submit->create
      @user = session[:user]
      if !@user
        redirect_to :action => :new
      end
    
      @message = @user.messages.new(params[:message]) 
      # The same Please use above
      #@message = Messaga.new(params[:message])
      #@message.user = @user
      
      if @message.save
        flash[:notice] = "message was successfully created"
        redirect_to :action => messages_url(@message)
      else
        render :action => :new
      end
  end
  
  def update #unused
   
    if @message.update_attributes(params[:message])
      redirect_to :action => :show, :id => @message
      flash[:notice] = "message was successfully updated"
    else
      render :action => :edit
    end
    
  end
  
  def new
    if !session[:access_token]
      redirect_to Koala::Facebook::OAuth.new.url_for_oauth_code(:callback => new_message_url)#go to fb then back
    end    
    
      session[:access_token] = Koala::Facebook::OAuth.new(new_message_url).get_access_token(params[:code]) if params[:code]
      # TODO: Create user here 1. Find if facebook_id exists 2. if not, create user 
      #                        3. update cached name 4. save user object to session
    
    
      @message = Message.new
      
      @access_token = session[:access_token]
      @graph = Koala::Facebook::GraphAPI.new(@access_token)
      userfile = @graph.get_object("me")
      fbid = userfile["id"]
      link = userfile["link"]
      name = userfile["name"]
      picture_url = @graph.get_picture("me")
    
    
      if User.where(:facebook_id=>fbid) == [] #if fbid not exist
        user = User.new(:link=>link, :name=>name, :picture_url=>picture_url, :facebook_id=>fbid)
    
      else #if fbid exist
        user = User.where(:facebook_id => fbid).first
        user.update_attributes(:link=>link, :name=>name, :picture_url=>picture_url, :facebook_id=>fbid)
      end
    
      user.save
      session[:user] = user
    
  end
  
  protected
  def find_message
    @message = Message.find(params[:id])
  end
  
  def check_session
    if !session[:user]
      redirect_to :action => :index
    end
  end
  
end
