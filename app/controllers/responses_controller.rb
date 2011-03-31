class ResponsesController < ApplicationController
before_filter :find_response, :only => [ :show, :edit, :update, :destroy]
  
  def index
    @responses = Response.page(params[:page]).per(5)
  end
  
  def show
  end
  
  def edit #edit->update
  end
  
  def new    #new->create
		@response = Response.new
  end
  
  def update
	
    
    if @response.update_attributes(params[:response])
			flash[:notice] = "response was successfully updated"
      redirect_to :action => :show, :id => @response
    else
      render :action => :edit
    end
  end
  
  def destroy
    @response.destroy
		redirect_to :action => :index
  end
  
  def create
		@response = Response.new(params[:response])
		if @response.save
			flash[:notice] = "response was successfully created"
			redirect_to :action => responses_url(@event)
		else
			render :action => :new
		end
  end

	protected
	def find_response
		@response = Response.find(params[:id])
	end
  

end
