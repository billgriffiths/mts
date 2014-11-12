class AnswerRecordsController < ApplicationController
  before_action :set_answer_record, only: [:show, :edit, :update, :destroy]

  # GET /answer_records
  def index
    @answer_records = AnswerRecord.all
  end

  # GET /answer_records/1
  def show
    @answer_record = AnswerRecord.find(params[:id])
  end

  # GET /answer_records/new
  def new
    @answer_record = AnswerRecord.new
  end

  # GET /answer_records/1/edit
  def edit
    @answer_record = AnswerRecord.find(params[:id])
  end

  # POST /answer_records
  # POST /answer_records.json
  def create
    @answer_record = AnswerRecord.new(answer_record_params)

      if @answer_record.save
        redirect_to @answer_record, notice: 'Answer record was successfully created.' 
      else
        render :new 
      end
  end

  # PATCH/PUT /answer_records/1
  def update
      if @answer_record.update(answer_record_params)
        fredirect_to @answer_record, notice: 'Answer record was successfully updated.' 
      else
        render :edit 
      end
  end

  # DELETE /answer_records/1
  def destroy
    @answer_record.destroy
      fredirect_to answer_records_url, notice: 'Answer record was successfully destroyed.' 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer_record
      @answer_record = AnswerRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_record_params
      params.require(:answer_record).permit(:problem, :decoded_answer, :start_time)
    end
end
