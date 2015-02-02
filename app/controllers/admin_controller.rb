class AdminController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]

  # GET /admins
  # GET /admins.json
  def index
  end

    layout "admin"

    before_filter :authorize_access, :except => :login

    def try_test
      if request.post?
        @test = TestTemplate.find(params[:test])
        @test_list = TestTakerController.generate_test_form(@test.template)
        session[:test_list] = @test_list
        redirect_to( :action => 'show_test_try')
      end
    end

    def show_test_try
      @answers = nil
      @test_list = session[:test_list]
      @test_title = @test_list[0]
      @test_instructions = @test_list[1]
      @n = @test_list[2].to_i
      @test_list = @test_list.drop(4)
     if @answers.nil?
        @answers = Answers.new
        @answers.items = Array.new(@n) {|i| (i+1).to_s}
      end
      session[:answers] = @answers
    end

    def score_try
        require 'open-uri'
        require 'pp'
#        answers = session[:answers].items
        @test_list = session[:test_list]
        n = @test_list.length
        choices = []
        l = "A"
        26.times do 
        	 choices << l
           l = l.succ
        end
        i = 0
        score = 0
        @user_answers = []
        @key = []
        @missed_questions = []
        @test_list.each do |p|
          code = p[p.length-1,1]
          if code == "m"
            i += 1
            keystring = p.split("/")[3].split(".")[0].gsub(",","")
            number_choices = keystring.length
            key_answer = choices[keystring.index("1")]
            @key << key_answer
            # temp_answer = answers[i-1].split(" ")
            # temp_answer.delete_at(0)
            # user_answer = temp_answer.to_s
            if !params[i.to_s].nil?
              user_answer = params[i.to_s]
            else
              user_answer = ""
            end
            @user_answers << user_answer
            if user_answer == key_answer
              score += 1
            else
              @missed_questions << i.to_s + "<*>" + user_answer + "<*>" + key_answer +"<*>" + p
            end
          elsif code == "f"
            i += 1
            temp_answer = answers[i-1].split(" ")
            temp_answer.delete_at(0)
            user_answer = temp_answer.to_s
            parray = p.split("?")[1].split("&")
            open("http://math.lanecc.edu/getproblemanswers?problem=#{parray[0].split("=")[1]}&seed=#{parray[3].split("=")[1]}&useranswer=#{user_answer}") do |f|
              keystring = f.gets
            end
            keyarray = keystring.split(";<br>")
            key_answer = keyarray[0]
            @key << key_answer
            @user_answers << user_answer
            if keyarray[1].to_i == 1
              score += 1
            else
              @missed_questions << i.to_s + "<*>" + user_answer + "<*>" + key_answer +"<*>" + p
            end
          end
        end
        @score = score/1.0/i
    end

    def update_answers
      if @answers.nil?
        @answers = Answers.new
      end
      answer = params[:answer]
      @answer = answer
      answerarray = answer.split(" ")
      i = answerarray[0].to_i
      @answers.items[i-1] = answer
    end

    def get_student_record
      session[:student_action] = "show_record"
      redirect_to(:controller => 'students', :action => 'choose_student')
    end

    def authorize
  #    @student_pages, @students = paginate :students, :per_page => 10
      @students = Student.all
      session[:student_action] = "authorize"
      redirect_to(:controller => 'students', :action => 'choose_student')
    end

    def authorize_reentry
      session[:student_action] = "authorize_reentry"
      redirect_to(:controller => 'students', :action => 'choose_student')
    end

    def authorize_class
      @user = User.find(session[:user_id])
      if session[:instructor]
        @instructor = Instructor.find(session[:instructor])
      end
      if request.post? or not params[:course].nil?
        @select_all = params[:select_all]
        if @select_all.nil?
          @select_all = "false"
        end
        @course = Course.find(params[:course])
        if not params[:test].nil?
          @test = TestTemplate.find(params[:test])
        end
        @students = []
        Student.all.each do |s|
          if s.courses.include?(@course)
            @students << s
          end       
        end
      end
    end
    
    def authorize_class_test
      @students = params[:students]
      @course = Course.find(params[:course])
      @test = TestTemplate.find(params[:test])
      @checked_students = params[:checked_student] 
      @student_testers = []
      @start_time = Time.now
      @time_limit = params[:time_limit].to_i*60
      @end_time = @start_time + @time_limit
      if not @students.nil?
        @students.each do |s|
          if params[:checked_student][s] == '1'
            @student = Student.find(s)
            @student_testers << @student
            TestResult.destroy_all("status = 'authorized' and student_id = #{s}")
            test_result = TestResult.new
            test_result.status = 'authorized'
            test_result.student = @student
            test_result.test_template = @test
            test_result.start_time = @end_time
            test_result.course = @course
            test_result.save
            @student.add_test_result(test_result)
            @student.save
          end
        end
      end
      
    end

    def add_test_to_course
      if request.post?
        @test = TestTemplate.find(params[:test])
        @course = Course.find(params[:course])
        if @test.courses.detect {|c| c == @course}
          flash[:notice] = "#{@course.course_name} already has #{@test.name}"
        else
          @test.add_course(@course)
          flash[:notice] = "#{@test.name} has been successfully added to #{@course.course_name}"
        end
        @test.save
      end
    end

    def add_student_to_course
      @course = Course.find(params[:course])
      if request.post? 
        if not params[:student][:student_number].blank?
          @old_student = Student.find_by_student_number(params[:student][:student_number])
          if @old_student and @old_student.first_name == params[:student][:first_name] and @old_student.last_name == params[:student][:last_name]
            if @course.students.detect {|s| s == @old_student}
              flash[:notice] = "#{@student.first_name} #{@student.last_name} is already enrolled in #{@course.course_name}"
            else
              @old_student.add_course(@course)
              flash[:notice] = "Old student #{@old_student.first_name} #{@old_student.last_name} successfully enrolled in #{@course.course_name}"
            end
          elsif @old_student.nil?
            @student = Student.new
            @student.student_number = params[:student][:student_number]
            @student.last_name = params[:student][:last_name]
            @student.first_name = params[:student][:first_name]
            if @student.save
              @student.add_course(@course)
              flash[:notice] = "New student #{@student.first_name} #{@student.last_name} successfully enrolled in #{@course.course_name}"
              redirect_to(:controller => 'admin', :action => 'show_class')
            end
          end
        else
          flash[:notice] = "Error, student number is blank. #{params.to_s}"
        end
      end
    end

    def add_students #adding students to a class from a spreadsheet
      @instructor = session[:instructor] #actually instructor id
      @classes = session[:courses] #instructor classes
      @n = session[:n]
      if request.post? 
        @course = Course.find(params[:course])
        if @course.nil?
          flash[:notice] = "Course not selected."
        else
          @students = []
          @students_already_enrolled = []
          @students_errors = []
          student_data = params["student_data"].gsub("\r","").split("\n")
          @course = Course.find(params[:course])
          if student_data.blank?
            flash[:notice] = "No student data given."
          else
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
                    @students_already_enrolled << @student
                  else
                    @student.add_course(@course)
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
              end
            end
          end
        end
      end
    end

    def new_user
      @user = User.new(params[:user])
      if request.post? and @user.save
        flash.now[:notice] = "User #{@user.user_name} created"
      end
    end

    def add_user
      @user = User.new(params[:user])
      if request.post? and @user.save
        flash.now[:notice] = "User #{@user.user_name} created"
      end
    end

    def add_course
      @course = Course.new(params[:course])
      if request.post? and @course.save
        @instructor = Instructor.find(params[:instructor])
        @instructor.add_course(@course)
        flash[:notice] = "#{@course.course_name} #{@course.class_number} sucessfully added to #{@instructor.first_name} #{@instructor.last_name}"
      end
    end

    def add_student
      @student = Student.new(params[:student])
      if request.post? and @student.save
        flash.now[:notice] = "Student #{@student.student_number} #{@student.first_name} #{@student.last_name} created"
      end
    end

    def delete_user
      if request.post?
        user = User.find(params[:id])
        begin
          user.destroy
          flash[:notice] = "User #{user.name} deleted"
        rescue Exception => e
          flash[:notice] = e.message
        end
      end
      redirect_to(:action  => :list_users)
    end

  #  def list_users
  #    user = User.find_by_id(session[:user_id])
  #    if user 
  #      if user.testing_system.blank?
  #        @all_users = User.find(:all)
  #      else
  #        @all_users = User.find_all_by_testing_system(user.testing_system)
  #      end
  #    else
  #      @all_users = User.find(:all)
  #    end
  #  end

#    def index
 #     list_users
  #    render :action => 'list_users'
   # end

    # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#    verify :method => :post, :only => [ :destroy, :create, :update ],
 #          :redirect_to => { :action => :list }

 def show_class
   @user = User.find(session[:user_id])
   if session[:instructor]
     @instructor = Instructor.find(session[:instructor])
   end
   if request.post?
     @course = Course.find(params[:course])
     @students = []
     Student.all.each do |s|
       if s.courses.include?(@course)
         @students << s
       end       
     end
   end
 end

    def list_users
      @users = User.all
#      @user_pages, @users = paginate :users, :per_page => 10
    end

    def show_user
      @user = User.find(params[:id])
    end

    def new_user
      @user = User.new
    end

    def create_user
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = 'User was successfully added.'
        redirect_to :action => 'list_users'
      else
        render :action => 'new_user'
      end
    end

    def edit_user
      @user = User.find(params[:id])
    end

    def update_user
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        redirect_to :action => 'show_user', :id => @user
      else
        render :action => 'list_user'
      end
    end

    def destroy_user
      User.find(params[:id]).destroy
      redirect_to :action => 'list_users'
    end

    def login
      session[:user_id] = nil
      if request.post?
        user = User.where(:user_name => params[:user_name]).first
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          if user.role == "instructor"
            instructor = Instructor.where(["first_name = ? and last_name = ?",user.first_name,user.last_name] ).first
            if instructor
              session[:instructor] = instructor.id
              session[:courses] = instructor.courses
              session[:n] = session[:courses].length
            else
              session[:instructor] = nil
              session[:courses] = []
            end
          else
            session[:instructor] = nil
            session[:courses] = nil
          end
          url = session[:orginal_url]
          session[:original_url] = nil
          redirect_to(url || {:action => "index"})
        else
          flash[:notice] = "Invalid user name or password"
        end
      end
    end

    def logout
      session[:user_id] = nil
      session[:courses] = nil
      flash[:notice] = "logged out"
      redirect_to(:action  => "login")
    end
    
end
 