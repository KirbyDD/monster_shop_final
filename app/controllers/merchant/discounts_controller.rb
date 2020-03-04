class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def new
  end

  def create
    discount = current_user.merchant.discounts.create(discount_params)
    if discount.save
      flash[:success] = 'Discount Created'
      redirect_to '/merchant/discounts'
    else
      flash[:error] = 'Discount Not Created. Please try again.'
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    if @discount.save
      flash[:success] = 'Discount Updated'
      redirect_to '/merchant/discounts'
    else
      flash[:error] = 'Discount Not Updated. Please try again.'
      render :edit
    end
  end

  def destroy
    Discount.find(params[:id]).destroy
    flash[:success] = 'Discount Deleted'
    redirect_to '/merchant/discounts'
  end

  private

    def discount_params
      params.permit(:percentage, :quantity)
    end

end
