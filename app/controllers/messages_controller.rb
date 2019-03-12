class MessagesController < ApplicationController
	before_action :find_message, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!,  except: [:index, :show]

	def index

		locals messages: Message.all.order("created_at DESC").paginate(:page => params[:page])
	end

	def show 
		locals message: @message
	end

	def new
		@message = current_user.messages.new
		locals message: @message
	end

	def create
		@message = current_user.messages.new(message_params)
		if @message.save
			save_picture
			flash[:success] = "Message saved successfully..!"
			redirect_to root_path
		else 
			flash[:danger] = "Oops..! Message not saved write again..!"
			render 'new'
		end
	end

	def edit
		locals message: @message
	end

	def update
		if @message.update(message_params)
			unless @message.picture.nil?
				@message.picture.destroy
			end
			save_picture
			flash[:success] = "Message updated successfully..!"
			redirect_to message_path
		else
			flash[:danger] = "Oops..! Message not updated do again..!"
			locals message: @message
		end
	end

	def destroy
		@message.destroy
		flash[:info] = "Message is deleted successfully..!"
		redirect_to root_path
	end



	private
		def message_params
			params.require(:message).permit(:title, :description)
		end

		def save_picture
		   	pic = params[:message][:picture]
		    unless pic.nil?
		    	pic_name = pic.original_filename
		    	pic_hash = {"name" => pic_name, "imageable_id" => @message.id, "imageable_type" => 'Message'}
			    picture = Picture.create(pic_hash)
			    upload
		    end
	    end

	    def upload
		  	uploaded_io = params[:message][:picture]
		 	File.open(Rails.root.join('app','assets','images',uploaded_io.original_filename),'wb') do |file|
		    	file.write(uploaded_io.read)
		  	end
		end

		def find_message
			@message = Message.find_by_id(params[:id])
		end

		def locals(values)
		  	render locals: values
		end
end