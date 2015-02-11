class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  layout "admin"

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
    @params = params
    if request.post? and @course.save
      @instructor = Instructor.find(params[:course][:instructor])
      @instructor.add_course(@course)
      flash[:notice] = "#{@course.course_name} #{@course.class_number} sucessfully added to #{@instructor.first_name} #{@instructor.last_name}"
    end
   redirect_to @course
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
  
  def remove_test
    @course = Course.find(params[:course])
    @course.tests.delete(params[:test])
  end

  def remove_student
    @student = Student.find(params[:student])
    @course = Course.find(params[:course])
    @course.students.delete(@student)
    redirect_to(:controller => 'admin', :action => 'show_class')
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
