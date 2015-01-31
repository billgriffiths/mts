class TestTakerController < ApplicationController

  require "rexml/document"
  include REXML  # so that we don't have to prefix everything with REXML::...
  
  layout "test_taker"

    def TestTakerController.section_problem_list(section)
      problem_list = []
      name = section.elements[2].elements[2].text
      instructions = section.elements[2].elements[4].text
      problem_list << name + "/s"
      if instructions.blank?
        problem_list << "/i"
      else
        problem_list << instructions + "/i"
      end
      randomize = section.elements[2].elements[8].to_s
      number_questions = section.elements[2].elements[10].text.to_i
      if randomize == "<true/>"
        entriesArray = shuffle(section.elements["array"].elements.to_a)
      else
        entriesArray = section.elements["array"].elements
      end
      i = 0
      number_questions.times do
        e = entriesArray[i]
        key = e.elements[1]
        if key.text == "Section"
          section_list = section_problem_list(e)
          section_list.each { |p| problem_list << p }
          problem_list << "/e" # end of section
        else
          name = e.elements[4].text
          multiple_choice = e.elements[6].to_s
          if multiple_choice == "<true/>"
            multiple_choice = "m"
          else
            multiple_choice = "f"
          end
          ext = name.split(".").last
          if ext == "5jpg"
            dir = "problems/5multchoiceimages"
            name.chomp!("."+ext)
            keystring = shuffle([1,2,3,4,5]).to_s
          elsif ext == "pedr"
            dir = "problems/PEmultchoiceimages"
            name.chomp!("."+ext)
            keystring = shuffle([1,2,3,4]).join(",")
          elsif ext == "pedx"
            dir = "problems/PEXmultchoiceimages"
            name.chomp!("."+ext)
            keyarray = []
            choices = e.elements[8].text.split(",")
            num_choices = choices[0].to_i
            if choices[1] == "none"
              1.upto(num_choices-1) {|t| keyarray << t}
              keystring = (shuffle(keyarray) << num_choices).join(",")
            else
              1.upto(num_choices) {|t| keyarray << t}
              keystring = shuffle(keyarray).join(",")
            end
          else
            dir = "problems/MRC"
            keystring = shuffle([1,2,3,4]).join(",")
          end
          problem = "#{dir}/#{name}/#{keystring}.jpg/#{multiple_choice}"
          problem_list << problem
          if i == entriesArray.length-1
            i = 0
            if randomize == "<true/>"
              entriesArray = shuffle(section.elements["array"].elements.to_a)
            else
              entriesArray = section.elements["array"].elements
            end
          else
            i += 1
          end
        end
      end
      return problem_list
    end

    def TestTakerController.shuffle(theArray)
      n = theArray.length
      for i in 0..n-2
        j = rand(n-i) # 0<=j<=n-i-1
        t = theArray[j] #swap the jth elt with the n-i-1th elt
        theArray[j] = theArray[n-i-1]
        theArray[n-i-1] = t
      end
      return theArray
    end

    def TestTakerController.generate_test_form(test_template)
      require "rexml/document"
      srand Time.now.to_i
      problem_list = []
      doc = REXML::Document.new(test_template)
      testsection = doc.root.elements["dict"]
      problem_list <<  testsection.elements[2].elements[2].text # test name, 0 on problem_list
      number_questions = testsection.elements[2].elements[10].text
  #    @answers.items = Array.new(number_questions.to_i) {|i| i}
      problem_list << testsection.elements[2].elements[4].text # test instructions, 1 on problem_list
      randomize = testsection.elements[2].elements[8].to_s 
  #    @numberQuestions = number_questions
      problem_list << number_questions                        # 2 on problem_list
      if testsection.elements[2].elements[11]
        problem_list << testsection.elements[2].elements[12].text # resource URL for test if exists, 3 on problem_list
      else
        problem_list << ""
      end
  #    resource = testsection.elements[2].elements[12].text 
      if randomize == "<true/>"
        entriesArray = shuffle(testsection.elements["array"].elements.to_a)
      else
        entriesArray = testsection.elements["array"].elements
      end
      entriesArray.each do |e|
        key = e.elements[1]
        if key.text == "Section"
          section_list = section_problem_list(e)
          section_list.each { |p| problem_list << p }
          problem_list << "/e" # end of section
        else
          name = e.elements[4].text
          multiple_choice = e.elements[6].to_s
          if multiple_choice == "<true/>"
            multiple_choice = "m"
            ext = name.split(".").last
            if ext == "5jpg"
              dir = "problems/5multchoiceimages"
              name.chomp!("."+ext)
              keystring = shuffle([1,2,3,4,5]).to_s
            elsif ext == "pedr"
              dir = "problems/PEmultchoiceimages"
              name.chomp!("."+ext)
              keystring = shuffle([1,2,3,4]).join(",")
            elsif ext == "pedx"
              dir = "problems/PEXmultchoiceimages"
              name.chomp!("."+ext)
              keyarray = []
              choices = e.elements[8].text.split(",")
              num_choices = choices[0].to_i
              if choices[1] == "none"
                1.upto(num_choices-1) {|t| keyarray << t}
                keystring = (shuffle(keyarray) << num_choices).join(",")
              else
                1.upto(num_choices) {|t| keyarray << t}
                keystring = shuffle(keyarray).join(",")
              end
            else
              dir = "problems/MRC"
              keystring = shuffle([1,2,3,4]).join(",")
            end
            problem = "#{dir}/#{name}/#{keystring}.jpg/#{multiple_choice}"
          else
            multiple_choice = "f"
            name = URI.encode(name)
            problem = "getproblem.php?name=#{name}&key=5876&number=1&seed=2011919915&n=3&multipleChoice=0/#{multiple_choice}"
          end
          problem_list << problem
        end
      end
      return problem_list
    end

  def show_test
    if @answers.nil?
      @answers = Answers.new
    end
    @test_results = TestResult.find(params[:test_results])
    if @test_results.status == 'finished'
      flash[:notice] = "This test has already been completed and scored."
    end
    @test = TestTemplate.find(@test_results.test_template)
    if @test_results.test_items.nil?
      @test_list = TestTakerController.generate_test_form(@test.template)
      @test_results.test_items =  @test_list.join("<*>")
      @test_results.status = 'started'
    else
      @test_list = @test_results.test_items.split("<*>")
    end
    @n = @test_list[2].to_i
    if @test_results.answers.nil?
      @answers.items = Array.new(@n) {|i| (i+1).to_s+"."}
      @test_results.answers = @answers.items.join("<*>")
    else
      @answers.items = @test_results.answers.split("<*>")
    end
    @test_results.save
    session[:test_results_id] = @test_results.id
  end

  def update_answers
    if @answers.nil?
      @answers = Answers.new
    end
    answer = params[:answer]
    answerarray = answer.split(" ")
    i = answerarray[0].to_i
    @current_answer = answer
    @test_results = TestResult.find(session[:test_results_id])
    @answers.items = @test_results.answers.split("<*>")
    if @test_results.status == 'finished'
      @current_answer = @answers.items[i-1]
    else
      @answers.items[i-1] = answer
      @test_results.answers = @answers.items.join("<*>")
      @test_results.save
    end
    respond_to do |format|
      format.js
    end
  end
   
end
