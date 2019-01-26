class UrlsController < ApplicationController

  def show
    @url = Url.friendly.find(params[:id])
    redirect_to ("#{@url.link}")
  end

  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
    if @url.save
      flash[:created] = "Your url for link is: https://b3v3-url-shortener.herokuapp.com/url/#{@url.shortening}"
      redirect_to '/url/new'
    else
      render 'new'
    end
  end

private
  def url_params
    params.require(:url).permit(:link, :days_to_delete, :shortening )
  end
end
