class ResponsesController < ApplicationController
#before_filter :find_response, :only => [ :show, :edit, :update, :destroy]
  
  def index
    @responses = Response.page(params[:page]).per(5)
  end
  
  def show
  end
  
  def edit #edit->update
    @response = Response.find(params[:id])
  end
  
  def new    #new->create
		@response = Response.new
  end
  
  def update
    @response = Response.find(params[:id])
    if @response.update_attributes(params[:response])
			flash[:notice] = "response was successfully updated"
      redirect_to :action => :index, :controller => :messages #***how to use Restful***
    else
      render :action => :edit
    end
  end
  
  def destroy
    @response = Response.find(params[:id])
    @response.destroy
    flash[:notice] = "response was successfully deleted"
		redirect_to :action => :index, :controller => :messages #***how to use Restful***
  end
  
  def create
		#@response = @message.response.new(params[:response])
		@message = Message.find(params[:message_id])
		#@response = @message.response.new(params[:response]) #***why not work***
		@response = Response.new(params[:response])
		#@response.message = @message #this way or ?
	  @message.response = @response
	  
		if @response.save
			flash[:notice] = "response was successfully created"
			redirect_to :action => :index, :controller => :messages #***how to use Restful***
		else
			render :action => :new
		end
  end

	protected
	def find_response
		@response = Response.find(params[:id])
    #@response = Response.find(params[:response])
	end
  

end
