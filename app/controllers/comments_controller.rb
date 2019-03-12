class CommentsController < ApplicationController
	before_action :find_message
	before_action :find_comment, only: [:edit, :update, :destroy]
	before_action :authenticate_user!

	def create
		@comment = @message.comments.new(comment_params)
		if @comment.valid?
			@comment.user_id = current_user.id
			if @comment.save
				save_picture
				flash[:success] = "Comment created successfully..!"
				redirect_to message_path(@message)
			else
				flash[:danger] = "Oopes..! Comment not created..!"
				render 'new'
			end
		else
			redirect_to @message, alert: 'Invalid comment'
		end
	end

	def edit
		locals message: @message, comment: @comment
	end

	def new
		@comment = @message.comments.new
	end

	def update
		if @comment.update(comment_params)
			unless @comment.picture.nil?
				@comment.picture.destroy
			end
			save_picture
			flash[:success] = "Comment updated successfully..!"
			redirect_to message_path(@message)
		else
			flash[:danger] = "Oopes..! Comment failed to update..!"
			render 'edit'
		end
	end

	def destroy
		@comment.destroy
		flash[:info] = "Comment deleted successfully..!"
		redirect_to message_path(@message)
	end

	def index
		locals comments: @message.comments
	end


	private
		def find_message 
			@message = Message.find_by_id(params[:message_id])
		end

		def find_comment
			@comment = @message.comments.find_by_id(params[:id])
		end

		def comment_params
			params.require(:comment).permit(:content)
		end

		def locals(values)
		  	render locals: values
		end

		def save_picture
			pic = params[:comment][:picture]
		    unless pic.nil?
		    	pic_name = pic.original_filename
		    	pic_hash = {"name" => pic_name, "imageable_id" => @comment.id, "imageable_type" => 'Comment'}
			    picture = Picture.create(pic_hash)
			    upload
		    end
	    	
	    end

	    def upload
		  	uploaded_io = params[:comment][:picture]
		 	File.open(Rails.root.join('app','assets','images',uploaded_io.original_filename),'wb') do |file|
		    	file.write(uploaded_io.read)
		  	end
		end
end
