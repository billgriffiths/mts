class StudentsController < ApplicationController
#  before_action :set_student, only: [:show, :edit, :update, :destroy]

layout "admin"

  # GET /students
  def index
    @students = Student.all
  end

  # GET /students/1
  def show
    @student = Student.find(params[:id])
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
  end

  # POST /students
  def create
    @student = Student.new(student_params)

      if @student.save
         redirect_to @student, notice: 'Student was successfully added.' 
      else
         render :new 
      end
    end

  # PATCH/PUT /students/1
  def update
      if @student.update(student_params)
         redirect_to @student, notice: 'Student was successfully updated.' 
       else
         render :edit 
      end
    end

  # DELETE /students/1
  def destroy
    @student.destroy
       redirect_to students_url, notice: 'Student was successfully destroyed.' 
    end

    def choose_student
      if request.post?
        if not params[:letter].blank?
           letter = "#{params[:letter]}%"
          @students = Student.where(["last_name ILIKE ?",letter])      
        else
          @students = Student.where( ["last_name ILIKE ? and first_name ILIKE ? and student_number ILIKE ?","#{params[:last_name]}%","#{params[:first_name]}%","#{params[:student_number]}%"])
        end
        if @students.empty?
          user = User.find(session[:user_id])
          if user.role == "instructor"
            flash[:notice] = "No matching students found for instructor #{user.last_name}."
          else
            flash[:notice] = "No matching students found."
          end
        end
      end
    end

    def show_record
      @student = Student.find(params[:id])
      @course = Course.find(params[:course])
      session[:student_action] = nil
    end

    def authorize
      @student = Student.find(params[:id])
      @course = Course.find(params[:course])
      session[:student_action] = nil
    end

    def authorize_reentry
      @student = Student.find(params[:id])
      session[:student_action] = nil
    end

    def authorize_reentry_test
      if request.post?
        test_results = TestResult.find(params[:id])
        test_results.status = "authorized"
        test_results.start_time = Time.now + params[:time_limit].to_i*60
        test_results.save
        @student = test_results.student
        @course = test_results.course
        @test = TestTemplate.find(test_results.test_template_id)
        flash[:notice] = "Test #{@test.name} was successfully authorized for #{@student.first_name} #{@student.last_name}."
      end
    end

    def authorize_test
      @student = Student.find(params[:student])
      @course = Course.find(params[:course])
      @test = TestTemplate.find(params[:test])
      TestResult.destroy_all("status = 'authorized' and student_id = #{params[:student]}")
      test_result = TestResult.new
      test_result.status = 'authorized'
      test_result.student = @student
      test_result.test_template = @test
      test_result.start_time = Time.now + params[:time_limit].to_i*60
      test_result.course = @course
      test_result.save
      @student.add_test_result(test_result)
      @student.save
      @message = "Test #{@test.name} was successfully authorized for #{@student.first_name} #{@student.last_name}."
    end

    def get_test
      if request.post?
        current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        @student = Student.find_by_student_number(params[:student_number])
        if @student.nil?
          flash[:notice] = "Student ID #{params[:student_number]} not found."
        else
          test_result = TestResult.where(["status = 'authorized' and student_id = #{@student.id} and start_time >= '#{current_time}'"])
          if test_result.length == 0
            flash[:notice] = "No tests are currently authorized for student id #{params[:student_number]}."
          else
            redirect_to(:controller => 'test_taker', :action => 'show_test', :student => params[:student_number], :test_results => test_result[0].id)
          end
        end
      end
    end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:first_name, :last_name, :student_number)
    end

end
