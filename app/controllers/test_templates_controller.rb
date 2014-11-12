class TestTemplatesController < ApplicationController
  before_action :set_test_template, only: [:show, :edit, :update, :destroy]

  # GET /test_templates
  def index
    @test_templates = TestTemplate.all
  end

  # GET /test_templates/1
  def show
    @test_template = TestTemplate.find(params[:id])
  end

  # GET /test_templates/new
  def new
    @test_template = TestTemplate.new
  end

  # GET /test_templates/1/edit
  def edit
    @test_template = TestTemplate.find(params[:id])
  end

  # POST /test_templates
  def create
    @test_template = TestTemplate.new(test_template_params)

      if @test_template.save
        redirect_to @test_template, notice: 'Test template was successfully created.' 
      else
         render :new 
      end
  end

  # PATCH/PUT /test_templates/1
  def update
      if @test_template.update(test_template_params)
        redirect_to @test_template, notice: 'Test template was successfully updated.' 
      else
        render :edit 
       end
  end

  # DELETE /test_templates/1
  def destroy
    @test_template.destroy
      redirect_to test_templates_url, notice: 'Test template was successfully destroyed.' 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_template
      @test_template = TestTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_template_params
      params.require(:test_template).permit(:name, :template, :description)
    end
end
