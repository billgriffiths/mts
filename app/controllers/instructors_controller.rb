class InstructorsController < ApplicationController
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]

  layout "admin"

  # GET /instructors
  # GET /instructors.json
  def index
    @instructors = Instructor.all
  end

  # GET /instructors/1
  def show
    @instructor = Instructor.find(params[:id])
  end

  # GET /instructors/new
  def new
    @instructor = Instructor.new
  end

  # GET /instructors/1/edit
  def edit
    @instructor = Instructor.find(params[:id])
  end

  # POST /instructors
  def create
    @instructor = Instructor.new(instructor_params)

      if @instructor.save
        redirect_to @instructor, notice: 'Instructor was successfully added.' 
      else
        render :new 
      end
   end

  # PATCH/PUT /instructors/1
  # PATCH/PUT /instructors/1.json
  def update
      if @instructor.update(instructor_params)
        redirect_to @instructor, notice: 'Instructor was successfully updated.' 
      else
        render :edit 
      end
  end

  # DELETE /instructors/1
  # DELETE /instructors/1.json
  def destroy
    @instructor.destroy
      redirect_to instructors_url, notice: 'Instructor was successfully destroyed.' 
   end

 def add_students #adding students to a class from a spreadsheet
   @instructor = session[:instructor] #actually instructor id
   @classes = session[:courses] #instructor classes
   @n = session[:n]
   if request.post? 
     @course = Course.find(params[:course])
     @students = []
     @students_already_enrolled = []
     @students_errors = []
     student_data = params["student_data"].gsub("\r","").split("\n")
     for s in student_data do
       t = s.split("\t")
       @student = Student.new
       @student.student_number = t[0]
       @student.last_name = t[1]
       @student.first_name = t[2]
       if not @student.student_number.blank?
         @old_student = Student.find_by_student_number(@student.student_number)
         if @old_student and @old_student.first_name == @student.first_name and @old_student.last_name == @student.last_name
           if @course.students.detect {|s| s == @old_student}
#                flash[:notice] = "#{@student.first_name} #{@student.last_name} is already enrolled in #{@course.course_name}"
             @students_already_enrolled << @student
           else
             @student.add_course(@course)
#                flash[:notice] += "Old student #{@student.first_name} #{@student.last_name} successfully enrolled in #{@course.course_name}"
             @students  << @student
           end
         elsif @student.save
            @student.add_course(@course)
            flash[:notice] += "New student #{@student.first_name} #{@student.last_name} successfully enrolled in #{@course.course_name}"
            @students  << @student
          else
            @students_errors  << @student
          end
       else
         @students_errors  << @student
#            flash[:notice] = "Error, student number is blank. #{@student.first_name} #{@student.last_name}"
       end
     end
   end
 end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instructor
      @instructor = Instructor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def instructor_params
      params.require(:instructor).permit(:first_name, :last_name)
    end
end
