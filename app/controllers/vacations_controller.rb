# frozen_string_literal: true

class VacationsController < ApplicationController
  include PrepareParamsByUserAccess

  before_action :set_vacation, only: %i[show edit update destroy]
  before_action :authorize_vacation
  before_action :predefine_vacation, only: :create

  # GET /vacations or /vacations.json
  def index
    @vacations = policy_scope(Vacation.all)
  end

  # GET /vacations/1 or /vacations/1.json
  def show; end

  # GET /vacations/new
  def new
    @vacation = Vacation.new
  end

  # GET /vacations/1/edit
  def edit; end

  # POST /vacations or /vacations.json
  def create
    respond_to do |format|
      if @vacation.save
        format.html { redirect_to vacation_url(@vacation), notice: t('.success') }
        format.json { render :show, status: :created, location: @vacation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vacation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vacations/1 or /vacations/1.json
  def update
    respond_to do |format|
      if @vacation.send(:update_vacation, vacation_params, current_user)
        format.html { redirect_to vacation_url(@vacation), notice: t('.success') }
        format.json { render :show, status: :ok, location: @vacation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vacation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vacations/1 or /vacations/1.json
  def destroy
    @vacation.destroy

    respond_to do |format|
      format.html { redirect_to vacations_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  private

  def predefine_vacation
    @vacation = Vacation.new(vacation_params.merge(user_id: current_user.id))
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_vacation
    @vacation = policy_scope(Vacation.all).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def vacation_params
    prepare_params!(params.require(:vacation).permit(:start_date, :end_date, :status))
  end

  def authorize_vacation
    authorize(Vacation)
  end
end
