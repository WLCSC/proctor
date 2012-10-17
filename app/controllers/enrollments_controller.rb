class EnrollmentsController < ApplicationController
  def create
	@enrollment = Enrollment.new(params[:enrollment])

	if @enrollment.save
      		redirect_to @enrollment.student, notice: 'Enrolled student.'
	else
		flash[:error] = @enrollment.errors[:base].join("<br/>").html_safe
		redirect_to @enrollment.student
	end		
  end

  def destroy
	  @enrollment = Enrollment.find(params[:id])

	  redirect_to @enrollment.student, notice: "Unenrolled student."
	  @enrollment.destroy
  end
end
