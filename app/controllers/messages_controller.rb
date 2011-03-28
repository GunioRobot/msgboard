class MessagesController < ApplicationController
before_filter :find_message, :only => [ :show, :edit, :update]   
  def index
    @messages = Message.all 
    #@messages = Message.page(params[:page]).per(5)
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
    @message = Message.new
    @hello = "chia"
  end
  
  def find_message
    @message = Message.find(params[:id])
  end
  
end
