class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses
  def index
    @courses = Course.all
  end

  # GET /courses/1
  def show
    @course = Course.find(params[:id])
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end

  # POST /courses
  def create
    @course = Course.new(course_params)

      if @course.save
        redirect_to @course, notice: 'Course was successfully created.' 
      else
        render :new 
      end
  end

  # PATCH/PUT /courses/1
  def update
      if @course.update(course_params)
        redirect_to @course, notice: 'Course was successfully updated.' 
      else
        render :edit 
      end
  end

  # DELETE /courses/1
  def destroy
    @course.destroy
      redirect_to courses_url, notice: 'Course was successfully destroyed.' 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:course_name, :class_number)
    end
end