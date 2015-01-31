class TestTemplatesController < ApplicationController
  before_action :set_test_template, only: [:show, :edit, :update, :destroy]

layout "admin"

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
  
  def show_test
      @test = TestTemplate.find(params[:id])
      @test_list = TestTakerController.generate_test_form(@test.template)
      session[:test_list] = @test_list
      redirect_to(:controller => :admin, :action => 'show_test_try')
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

    def save
      @test_template = TestTemplate.new
      @test_template.description = params[:description]
 #     @test_template.uploaded_test=params[:uploaded_test]
       uploaded_io = params[:uploaded_test]
 #      uploaded_io.original_filename), 'wb') do |file|
           @test_template.template = uploaded_io.read
 #     end
 @test_template.name       = File.basename(uploaded_io.original_filename.gsub(/[^\w._-]/, ''))
# @test_template.template   = test_field.read
#      @test_template.name = params[:name]

      if @test_template.save
         redirect_to(:action => 'show', :id => @test_template)
       else
         render(:action => :upload)
       end
    end

    def upload
     @test_template = TestTemplate.new(params[:test_template])
     @contents = ""
 if request.post?
   @test_template = TestTemplate.new
   @test_template.description = params[:description]
        uploaded_io = params[:picture]
#        File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
          @contents = uploaded_io.read
#        end
        @test_template.template = @contents
        @test_template.name = File.basename(uploaded_io.original_filename.gsub(/[^\w._-]/, ''))
        if @test_template.save
           redirect_to(:action => 'show', :id => @test_template)
         else
           render(:action => :upload)
         end
     end
    end
    
    def upload_test
      @test_template = TestTemplate.new(params[:test_template])
      redirect_to(:action => 'list')
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
