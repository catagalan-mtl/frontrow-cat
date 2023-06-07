require 'open-uri'
require 'nokogiri'

class ConcertsController < ApplicationController

  def index
    @city = params[:query_city]
    @artist = params[:query_artist]
    @concerts = Concert.all
    @concerts = Concert.search_by_city(@city) if @city.present?
    @concerts = Concert.search_by_artist(@artist) if @artist.present?
    @concerts = Concert.search_by_artist(@artist).search_by_city(@city) if @artist.present? && @city.present?
  end

  def show
    @concert = Concert.find(params[:id])
    @attendance = current_user.attendance_info(@concert)
    @review = Review.new
  end
end
