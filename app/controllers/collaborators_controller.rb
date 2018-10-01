class CollaboratorsController < ApplicationController
  def create
    @wiki = Wiki.find(params[:wiki_id])
    @user = User.find(params[:collaborator][:email])
    @collaborator = @wiki.collaborators.build(user: @user)

    if @collaborator.save
      flash[:notice] = "Collaboration created between #{@wiki.id} and #{@user.id}."
      redirect_to edit_wiki_path(@wiki)
    else
      flash[:alert] = "Collaboration failed."
      redirect_to @wiki
    end
  end

  def destroy
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = Collaborator.find(params[:id])

    if @collaborator.destroy
      flash[:notice] = "Collaboration deleted #{@collaborator.user.email}."
      redirect_to edit_wiki_path(@wiki)
    else
      flash[:alert] = "Collaboration failed."
      render edit_wiki_path
    end
  end

  private

  def collaborator_params
    params.require(:collaborator).permit(:wiki, :user, :collaborator)
  end
end
