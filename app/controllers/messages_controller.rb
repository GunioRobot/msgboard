class MessagesController < ApplicationController
before_filter :find_message, :only => [ :show, :edit, :update]   
  def index
    #@messages = Message.all 
    @messages = Message.page(params[:page]).per(5)
  end
  
  def show
  end
  
  def edit
  end
  
  #delete
  
  def create
      flash[:notice] = "message was successfully created"
      @message = Message.new(params[:message]) 
      if @message.save
        redirect_to :action => messages_url(@message)
      else
        render :action => :new
      end
  end
  
  def update
    flash[:notice] = "message was successfully updated"
    if @message.update_attributes(params[:message])
      redirect_to :action => :show, :id => @message
    else
      render :action => :edit
    end
    
  end
  
  def new
    if !params[:code]
      redirect_to Koala::Facebook::OAuth.new.url_for_oauth_code(:callback => new_message_url)
    end
    
    @message = Message.new
    
    session[:access_token] = Koala::Facebook::OAuth.new(new_message_url).get_access_token(params[:code]) if params[:code]
    @access_token = session[:access_token]
    @graph = Koala::Facebook::GraphAPI.new("#{@access_token}");
    
  end
  protected
  def find_message
    @message = Message.find(params[:id])
  end
  
end
