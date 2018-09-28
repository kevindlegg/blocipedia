class CollaboratorsController < ApplicationController

  def create
    @wiki = Wiki.find(params[:wiki_id])
    @user = User.find(params[:user_id])
    @collaborators = user.collaborators.build(wiki_id: wiki.id)

    if collaborators.save
      flash[:notice] = "Collaboration created between #{wiki.id} and #{user.id}."
    else
      flash[:alert] = "Collaboration failed."
    end

    redirect_to [wiki]
  end

  def destroy
    # wiki = Wiki.find(params[:wiki_id])
    # user = User.find(params[:user_id])
    collaborator = Collaborator.find(params[:id])

    if collaborator.destroy
      flash[:notice] = "Collaboration deleted between  #{collaborator.wiki_id} and #{collaborator.user_id}."
    else
      flash[:alert] = "Collaboration failed."
    end

    redirect_to [collaborator.wiki]
  end

  private

  def collaborator_params
    params.require(:collaborator).permit(:wiki, user_ids: [])
  end
end
