class WikisController < ApplicationController
  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = authorize Wiki.find(params[:id])
    @collabs = @wiki.users
  end

  def new
    @wiki = authorize Wiki.new
    @collabs = Collaborator.where(wiki_id: @wiki.id)
  end

  def edit
    @wiki = authorize Wiki.find(params[:id])
    @collabs = @wiki.collaborators
    @collab_users = User.all.reject{ |u| u == current_user}.collect{|u| [ u.email, u.id ] }
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    authorize @wiki
    @collabs = Collaborator.where(wiki_id: @wiki.id)

    if @wiki.save
      redirect_to wikis_path, notice: "Wiki was saved successfully."
    else
      flash.now[:alert] = "Error creating wiki. Please try again."
      render :new
    end
  end

  def update
    @wiki = authorize Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)

    if @wiki.save
      flash[:notice] = "Wiki was updated."
      redirect_to wikis_path
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :edit
    end
  end

  def destroy
    @wiki = authorize Wiki.find(params[:id])

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_path
    else
      flash.now[:alert] = "There was an error deleting the wiki."
      render :show
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
