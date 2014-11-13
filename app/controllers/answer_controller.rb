class AnswerController < ApplicationController

  layout "admin"
 
  def analyze_answers
    
  end
  
  def analyze_problem
    @problem_name = params[:name]
    @ext = @problem_name.split(".").last
    if @ext == "pedr" or ext == "jpg"
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
    @records = AnswerRecord.find(:all, "", :conditions => ["problem = ?", @problem_name])
    @records.each do |r|
      @frequency[r.decoded_answer] += 1
    end
  end
  
  def analyze_test
    require 'set'
    @test = TestTemplate.find(params[:test])
    @temp = @test.answer_records
    @test_problems = (@test.answer_records.collect {|r| r.problem}).uniq.sort
    @test_result_ids = (@test.answer_records.collect {|r| r.test_result_id}).uniq.sort {|a,b| TestResult.find(b).score <=> TestResult.find(a).score}
    @frequency = {}
    @test_result_ids.each do |id|
      @frequency[id] = []
      @test.answer_records.each {|a| @frequency[id] << a if a.test_result_id == id}
      @frequency[id].sort! {|a,b| a.problem <=> b.problem}
    end
  end

end
