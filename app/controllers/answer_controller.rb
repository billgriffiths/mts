class AnswerController < ApplicationController

  layout "admin"
 
  def analyze_answers
    
  end
  
  def analyze_problem
    @problem_name = params[:name]
    @ext = @problem_name.split(".").last
    if @ext == "pedr" or @ext == "jpg"
      @n = 4
    else
      @n = 5
    end
    @frequency = {}
    l = "A"
    @n.times do
      @frequency[l] = 0
      l = l.succ
    end
     @frequency["N"] = 0
    @records = AnswerRecord.where(["problem = ?", @problem_name])
    @records.each do |r|
      @frequency[r.decoded_answer] += 1
    end
  end
  
  def analyze_test
    require 'set'
    @test = TestTemplate.find(params[:test])
    @test_problems = (@test.answer_records.collect {|r| r.problem}).uniq.sort
#    @test_result_ids = (@test.answer_records.collect {|r| r.test_result_id}).uniq.sort {|a,b| TestResult.find(b).score <=> TestResult.find(a).score}
    @test_result_ids = (@test.answer_records.collect {|r| r.test_result_id}).uniq
    # @test_result_ids.sort_by do |r|
    #   TestResult.find(r).score 
    # end
    @test_result_ids = @test_result_ids.sort {|a,b| TestResult.find(b).score <=> TestResult.find(a).score}
    @frequency = {}
    @hist = []
    @total = {}
    @count = {}
    @test_problems.each do |p|
      @total[p] = 0
      @count[p] = 0
    end
    @test_result_ids.each do |id|
      @frequency[id] = []
      @hist[id] = {}
      @test.answer_records.each {|a| @frequency[id] << a if a.test_result_id == id}
      @frequency[id].each do |ans_rec|
        @hist[id][ans_rec.problem] = ans_rec.decoded_answer
        @count[ans_rec.problem] += 1
        if ans_rec.decoded_answer == "A"
          @total[ans_rec.problem] += 1
        end
      end
    end
  end

end
