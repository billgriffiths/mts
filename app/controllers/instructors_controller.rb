class InstructorsController < ApplicationController
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]

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
        redirect_to @instructor, notice: 'Instructor was successfully created.' 
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
