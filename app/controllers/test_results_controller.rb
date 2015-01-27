class TestResultsController < ApplicationController
  before_action :set_test_result, only: [:show, :edit, :update, :destroy]

  layout "admin"

  # GET /test_results
  def index
    @test_results = TestResult.all
  end

  # GET /test_results/1
  def show
    @test_result = TestResult.find(params[:id])
  end

  # GET /test_results/new
  def new
    @test_result = TestResult.new
  end

  # GET /test_results/1/edit
  def edit
    @test_result = TestResult.find(params[:id])
  end

  # POST /test_results
  def create
    @test_result = TestResult.new(test_result_params)

       if @test_result.save
        redirect_to @test_result, notice: 'Test result was successfully created.' 
      else
        render :new 
      end
  end

  # PATCH/PUT /test_results/1
  def update
      if @test_result.update(test_result_params)
        redirect_to @test_result, notice: 'Test result was successfully updated.' 
      else
        render :edit 
      end
  end

  # DELETE /test_results/1
  def destroy
    @test_result.destroy
    redirect_to test_results_url, notice: 'Test result was successfully destroyed.' 
  end

  def get_test
    if request.post?
      current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      @student = Student.find_by_student_number(params[:student_number])
      if @student
        test_result = TestResult.find(:all, :conditions => ["status = ? and student_id = ? and start_time >= ?",'authorized',@student.id,current_time])
        if test_result.length == 0
          flash[:notice] = "No tests are currently authorized for student id #{params[:student_number]}."
        else
          redirect_to(:controller => 'test_taker', :action => 'show_test', :student => params[:student_number], :test_results => test_result[0].id)
        end
      else
        flash[:notice] = "No student found with student id #{params[:student_number]}."
      end
    end
  end

  def score
    require 'open-uri'
    if session[:test_results_id]
      @test_results = TestResult.find(session[:test_results_id])
    else
      @test_results = TestResult.find(params[:test_results_id])
    end
    @student = Student.find(@test_results.student)
    if @test_results.status == 'finished'
      flash[:notice] = "This test has already been scored."
    end
    @test_results.status = 'finished'
    answers = @test_results.answers.split("<*>")
    @problem_list = @test_results.test_items.split("<*>")
    n = @problem_list.length
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
		answertonumber = ["A" => 1, "B" => 2, "C" => 3, "D" => 4, "E" => 5];
		numbertoanswer = ["","A","B","C","D","E"];
    AnswerRecord.destroy_all("test_result_id = #{@test_results.id}")
    answer_records = []
    answer_records_valid = true
    @problem_list.each do |p|
      code = p[p.length-1,1]
      if code == "m"
        i += 1
        folder = p.split("/")[1]
        problem = p.split("/")[2]
        if folder == "PEmultchoiceimages"
          problem += ".pedr"
        elsif folder == "5multchoiceimages"
          problem += ".5jpg"
        else
          problem += ".jpg"
        end
        keystring = p.split("/")[3].split(".")[0].gsub(",","")
        number_choices = keystring.length
        key_answer = choices[keystring.index("1")]
        @key << key_answer
        temp_answer = params[i.to_s]
        if temp_answer.nil?
          temp_answer = answers[i-1].split(" ")
          temp_answer = temp_answer[1]
        else
          answers[i-1] = i.to_s + " " + temp_answer
        end
        user_answer = temp_answer.to_s
        @user_answers << user_answer
        if user_answer == key_answer
          score += 1
        else
          @missed_questions << i.to_s + "<*>" + user_answer + "<*>" + key_answer +"<*>" + p
        end
        j = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".index(user_answer)
        if j.nil?
          decoded_answer = ""
        else
          decoded_answer = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[keystring[j,1].to_i-1,1]
        end
      elsif code == "f"
        i += 1
        temp_answer = answers[i-1].split(" ")
        temp_answer.delete_at(0)
        user_answer = temp_answer.to_s
        parray = p.split("?")[1].split("&")
        encoded_problem = parray[0].split("=")[1]
        problem = URI.decode(encoded_problem)
        keylines = []
        open("http://math.lanecc.edu/getproblemanswers?problem=#{encoded_problem}&seed=#{parray[3].split("=")[1]}&useranswer=#{user_answer}") do |f|
          keylines << f.readlines
        end
        keystring = keylines[0].to_s
        keyarray = keystring.split(";<br>")
        key_answer = keyarray[0]
        @key << key_answer
        @user_answers << user_answer
        decoded_answer = ""
        j = 0
        decoded_answer = "N"
        keylines.to_s.split("<br>\n").each do |k|
          if k.to_s.split(";<br>")[1].to_i == 1
            decoded_answer = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[j,1]
          end
          j += 1
        end
        if keyarray[1].to_i == 1
          score += 1
        else
          @missed_questions << i.to_s + "<*>" + user_answer + "<*>" + key_answer +"<*>" + p          
        end
        @keylines = keylines
      else
          next
      end
      answer_record = AnswerRecord.new(:problem => problem, 
                                      :decoded_answer => decoded_answer, 
                                      :start_time => @test_results.start_time,
                                      :test_result => @test_results,
                                      :course => @test_results.course,
                                      :test_template => @test_results.test_template )
      answer_records << answer_record
      if not answer_record.valid?
        answer_records_valid = false
      end
    end
    if answer_records_valid
      answer_records.each {|a| a.save}
    else
      flash[:notice] = "Unable to save answer records for data analysis as not all were valid."
    end
    @test_results.answers = answers.join("<*>")
    @score = score/1.0/i
    @test_results.score = score/1.0/i
    @test_results.save
  end

  def show_test
    @test_results = TestResult.find(params[:test_results_id])
    @time = @test_results.start_time
    @student = Student.find(@test_results.student_id)
    @test = TestTemplate.find(@test_results.test_template)
    @test_list = @test_results.test_items.split("<*>")
    @n = @test_list[2].to_i
    @answers = Answers.new
    @answers.items = @test_results.answers.split("<*>")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_result
      @test_result = TestResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_result_params
      params.require(:test_result).permit(:answers, :test_items, :score,:status, :start_time)
    end
end
