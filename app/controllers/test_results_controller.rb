class TestResultsController < ApplicationController
  before_action :set_test_result, only: [:show, :edit, :update, :destroy]

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
