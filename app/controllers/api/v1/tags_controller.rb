class Api::V1::TagsController < ApplicationController
  def index
    @tags = TrackedTag.where(current: true)
  end
end
